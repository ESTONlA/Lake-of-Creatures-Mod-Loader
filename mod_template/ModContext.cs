using System.Reflection;
using System.Text.Json;

using ImageMagick;
using UndertaleModLib.Compiler;
using UndertaleModLib;
using UndertaleModLib.Models;
using UndertaleModLib.Util;

namespace CreatureProbe;

internal sealed class ModContext
{
    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        AllowTrailingCommas = true,
        PropertyNameCaseInsensitive = true,
        ReadCommentHandling = JsonCommentHandling.Skip
    };

    private ModContext(UndertaleData data, string modRoot, ModManifest manifest)
    {
        Data = data;
        ModRoot = modRoot;
        Manifest = manifest;
        CodeFiles = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
    }

    public UndertaleData Data { get; }
    public string ModRoot { get; }
    public string AssetRoot => Path.Combine(ModRoot, "assets");
    public string CodeRoot => Path.Combine(AssetRoot, "code");
    public string DataRoot => Path.Combine(AssetRoot, "data");
    public ModManifest Manifest { get; }
    public Dictionary<string, string> CodeFiles { get; private set; }

    public static ModContext Create(UndertaleData data)
    {
        string modRoot = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)
            ?? throw new InvalidOperationException("Could not determine the mod assembly location.");

        ModContext context = new(data, modRoot, LoadManifest(modRoot));
        context.ReloadCodeFiles();
        return context;
    }

    public void ReloadCodeFiles()
    {
        CodeFiles = LoadCodeFiles(CodeRoot);
        Log($"Indexed {CodeFiles.Count} GML file(s) from {CodeRoot}.");
    }

    public void Log(string message)
    {
        Console.WriteLine($"[{Manifest.modName}] {message}");
    }

    public void Warn(string message)
    {
        Console.WriteLine($"[{Manifest.modName}] WARNING: {message}");
    }

    public string GetAssetPath(string relativeAssetPath)
    {
        string normalized = NormalizeAssetPath(relativeAssetPath).Replace('/', Path.DirectorySeparatorChar);
        string fullPath = Path.GetFullPath(Path.Combine(AssetRoot, normalized));
        string assetRoot = Path.GetFullPath(AssetRoot).TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);
        string assetRootWithSeparator = assetRoot + Path.DirectorySeparatorChar;

        if (!fullPath.Equals(assetRoot, StringComparison.OrdinalIgnoreCase)
            && !fullPath.StartsWith(assetRootWithSeparator, StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException($"Asset path '{relativeAssetPath}' escapes the mod assets folder.");
        }

        return fullPath;
    }

    public string RequireAssetPath(string relativeAssetPath)
    {
        string fullPath = GetAssetPath(relativeAssetPath);
        if (!File.Exists(fullPath))
        {
            throw new InvalidOperationException($"Missing required asset file '{relativeAssetPath}' at '{fullPath}'.");
        }

        return fullPath;
    }

    public byte[] LoadBinaryAsset(string relativeAssetPath) =>
        File.ReadAllBytes(RequireAssetPath(relativeAssetPath));

    public string LoadTextAsset(string relativeAssetPath) =>
        File.ReadAllText(RequireAssetPath(relativeAssetPath));

    public T? LoadJson<T>(string relativeAssetPath, bool required = true)
    {
        string fullPath = GetAssetPath(relativeAssetPath);
        if (!File.Exists(fullPath))
        {
            if (required)
            {
                throw new InvalidOperationException($"Missing required asset file '{relativeAssetPath}' at '{fullPath}'.");
            }

            return default;
        }

        try
        {
            return JsonSerializer.Deserialize<T>(File.ReadAllText(fullPath), JsonOptions);
        }
        catch (Exception ex)
        {
            throw new InvalidOperationException($"Could not parse JSON asset '{relativeAssetPath}'.", ex);
        }
    }

    public UndertaleGameObject CreateObject(
        string objectName,
        UndertaleSprite? sprite = null,
        bool visible = true,
        bool solid = false,
        bool persistent = false,
        UndertaleGameObject? parentObject = null)
    {
        UndertaleString name = new(objectName);
        UndertaleGameObject newObject = new()
        {
            Sprite = sprite,
            Persistent = persistent,
            Visible = visible,
            Solid = solid,
            Name = name,
            ParentId = parentObject
        };

        Data.Strings.Add(name);
        Data.GameObjects.Add(newObject);
        return newObject;
    }

    public UndertaleGameObject NewObject(
        string objectName,
        UndertaleSprite? sprite = null,
        bool visible = true,
        bool solid = false,
        bool persistent = false,
        UndertaleGameObject? parentObject = null) =>
        CreateObject(objectName, sprite, visible, solid, persistent, parentObject);

    public UndertaleRoom.GameObject PlaceObjectInRoom(string roomName, UndertaleGameObject objectToAdd, string layerName)
    {
        UndertaleRoom room = RequireRoom(roomName);
        UndertaleRoom.Layer layer = room.Layers.FirstOrDefault(candidate => candidate.LayerName?.Content == layerName)
            ?? throw new InvalidOperationException($"Could not find layer '{layerName}' in room '{roomName}'.");

        UndertaleRoom.GameObject instance = new()
        {
            InstanceID = Data.GeneralInfo.LastObj,
            ObjectDefinition = objectToAdd,
            X = -120,
            Y = -120
        };
        Data.GeneralInfo.LastObj++;

        if (layer.InstancesData is null)
        {
            throw new InvalidOperationException($"Layer '{layerName}' in room '{roomName}' does not accept object instances.");
        }

        layer.InstancesData.Instances.Add(instance);
        room.GameObjects.Add(instance);
        return instance;
    }

    public UndertaleRoom.GameObject AddObjectToRoom(string roomName, UndertaleGameObject objectToAdd, string layerName) =>
        PlaceObjectInRoom(roomName, objectToAdd, layerName);

    public UndertaleGameObject RequireObject(string name) =>
        Data.GameObjects.FirstOrDefault(candidate => candidate.Name?.Content == name)
        ?? throw new InvalidOperationException($"Could not find object '{name}'.");

    public UndertaleSprite RequireSprite(string name) =>
        Data.Sprites.FirstOrDefault(candidate => candidate.Name?.Content == name)
        ?? throw new InvalidOperationException($"Could not find sprite '{name}'.");

    public UndertaleRoom RequireRoom(string name) =>
        Data.Rooms.FirstOrDefault(candidate => candidate.Name?.Content == name)
        ?? throw new InvalidOperationException($"Could not find room '{name}'.");

    public UndertaleCode RequireCodeEntry(string name) =>
        Data.Code.FirstOrDefault(candidate => candidate.Name?.Content == name)
        ?? throw new InvalidOperationException($"Could not find code entry '{name}'.");

    public UndertaleFunction RequireFunction(string name) =>
        Data.Functions.FirstOrDefault(candidate => candidate.Name?.Content == name)
        ?? throw new InvalidOperationException($"Could not find function '{name}'.");

    public UndertaleScript RequireScript(string name) =>
        Data.Scripts.FirstOrDefault(candidate => candidate.Name?.Content == name)
        ?? throw new InvalidOperationException($"Could not find script '{name}'.");

    public UndertaleSound RequireSound(string name) =>
        Data.Sounds.FirstOrDefault(candidate => candidate.Name?.Content == name)
        ?? throw new InvalidOperationException($"Could not find sound '{name}'.");

    public UndertaleVariable RequireVariable(string name) =>
        Data.Variables.FirstOrDefault(candidate => candidate.Name?.Content == name)
        ?? throw new InvalidOperationException($"Could not find variable '{name}'.");

    public UndertaleSprite AddSpriteFromPng(
        string spriteName,
        string relativeAssetPath,
        int originX = 0,
        int originY = 0,
        bool transparent = true,
        bool smooth = false,
        bool preload = true)
    {
        RequireNewResourceName(spriteName, Data.Sprites.Select(sprite => sprite.Name?.Content), "sprite");

        string normalized = NormalizeAssetPath(relativeAssetPath);
        GMImage image = GMImage.FromPng(LoadBinaryAsset(normalized), verifyHeader: true);
        ValidateTextureSize(image.Width, image.Height, normalized);

        UndertaleEmbeddedTexture embeddedTexture = CreateEmbeddedTexture($"{spriteName}_texture", image);
        UndertaleTexturePageItem texturePageItem = CreateTexturePageItem($"{spriteName}_texture_page_item", embeddedTexture, image.Width, image.Height);

        UndertaleSprite sprite = new()
        {
            Name = Data.Strings.MakeString(spriteName),
            Width = (uint)image.Width,
            Height = (uint)image.Height,
            MarginLeft = 0,
            MarginTop = 0,
            MarginRight = image.Width - 1,
            MarginBottom = image.Height - 1,
            OriginX = originX,
            OriginY = originY,
            Transparent = transparent,
            Smooth = smooth,
            Preload = preload,
            BBoxMode = 0,
            SepMasks = UndertaleSprite.SepMaskType.AxisAlignedRect
        };

        sprite.Textures.Add(new UndertaleSprite.TextureEntry { Texture = texturePageItem });
        Data.Sprites.Add(sprite);
        AddSpriteToDefaultTextureGroup(sprite, embeddedTexture);

        Log($"Added sprite '{spriteName}' from '{normalized}'.");
        return sprite;
    }

    public void ReplaceSpriteTextureFromPng(string spriteName, string relativeAssetPath, int frame = 0)
    {
        UndertaleSprite sprite = RequireSprite(spriteName);
        if (frame < 0 || frame >= sprite.Textures.Count)
        {
            throw new InvalidOperationException($"Sprite '{spriteName}' does not have frame {frame}.");
        }

        string normalized = NormalizeAssetPath(relativeAssetPath);
        using MagickImage replacementImage = new(RequireAssetPath(normalized));
        sprite.Textures[frame].Texture.ReplaceTexture(replacementImage);

        Log($"Replaced sprite '{spriteName}' frame {frame} texture from '{normalized}'.");
    }

    public UndertaleSound AddSoundFromFile(
        string soundName,
        string relativeAssetPath,
        bool compressed = true,
        bool decodeOnLoad = true)
    {
        RequireNewResourceName(soundName, Data.Sounds.Select(sound => sound.Name?.Content), "sound");

        string normalized = NormalizeAssetPath(relativeAssetPath);
        string fullPath = RequireAssetPath(normalized);
        UndertaleSound.AudioEntryFlags flags = GetEmbeddedAudioFlags(fullPath, compressed, decodeOnLoad);
        UndertaleEmbeddedAudio embeddedAudio = CreateEmbeddedAudio($"{soundName}_audio", fullPath);
        int builtinGroupId = Data.GetBuiltinSoundGroupID();

        UndertaleSound sound = new()
        {
            Name = Data.Strings.MakeString(soundName),
            Type = Data.Strings.MakeString(Path.GetExtension(fullPath).ToLowerInvariant()),
            File = Data.Strings.MakeString(Path.GetFileName(fullPath)),
            Flags = flags,
            AudioGroup = Data.AudioGroups[builtinGroupId],
            GroupID = builtinGroupId,
            AudioFile = embeddedAudio,
            Volume = 1,
            Pitch = 0,
            Preload = true
        };

        Data.Sounds.Add(sound);
        Log($"Added sound '{soundName}' from '{normalized}'.");
        return sound;
    }

    public void ReplaceSoundFromFile(
        string soundName,
        string relativeAssetPath,
        bool compressed = true,
        bool decodeOnLoad = true)
    {
        UndertaleSound sound = RequireSound(soundName);
        int builtinGroupId = Data.GetBuiltinSoundGroupID();
        if (sound.GroupID != builtinGroupId)
        {
            throw new InvalidOperationException(
                $"Sound '{soundName}' is in audio group {sound.GroupID}. This helper only replaces embedded data.win sounds in group {builtinGroupId}.");
        }

        string normalized = NormalizeAssetPath(relativeAssetPath);
        string fullPath = RequireAssetPath(normalized);
        sound.Type = Data.Strings.MakeString(Path.GetExtension(fullPath).ToLowerInvariant());
        sound.File = Data.Strings.MakeString(Path.GetFileName(fullPath));
        sound.Flags = GetEmbeddedAudioFlags(fullPath, compressed, decodeOnLoad);
        sound.AudioFile = CreateEmbeddedAudio($"{soundName}_replacement_audio", fullPath);
        sound.Preload = true;

        Log($"Replaced sound '{soundName}' from '{normalized}'.");
    }

    public string AddIncludedFile(string relativeAssetPath) =>
        RequireIncludedFile(relativeAssetPath);

    public string RequireIncludedFile(string relativeAssetPath)
    {
        string normalized = NormalizeAssetPath(relativeAssetPath);
        if (!normalized.StartsWith("included/", StringComparison.OrdinalIgnoreCase))
        {
            normalized = "included/" + normalized;
        }

        _ = RequireAssetPath(normalized);
        Log($"Registered included file asset '{normalized}'.");
        return normalized;
    }

    public string GetIncludedFileGamePath(string relativeAssetPath)
    {
        string normalized = RequireIncludedFile(relativeAssetPath);
        string modFolderName = Path.GetFileName(ModRoot.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar));
        return $"loclm/mods/{modFolderName}/assets/{normalized}";
    }

    public string ReplaceTextOnce(string source, string search, string replacement, string label = "text")
    {
        int matches = CountOccurrences(source, search);
        if (matches != 1)
        {
            throw new InvalidOperationException($"Expected exactly one match for '{search}' in {label}, found {matches}.");
        }

        return source.Replace(search, replacement);
    }

    public string ReplaceTextExact(string source, string search, string replacement, int expectedMatches, string label = "text")
    {
        int matches = CountOccurrences(source, search);
        if (matches != expectedMatches)
        {
            throw new InvalidOperationException($"Expected {expectedMatches} match(es) for '{search}' in {label}, found {matches}.");
        }

        return source.Replace(search, replacement);
    }

    public int ReplaceGameString(string search, string replacement, int expectedMatches = 1)
    {
        int replaced = 0;
        foreach (UndertaleString gameString in Data.Strings)
        {
            if (gameString.Content != search)
            {
                continue;
            }

            gameString.Content = replacement;
            replaced++;
        }

        if (replaced != expectedMatches)
        {
            throw new InvalidOperationException($"Expected to replace {expectedMatches} game string(s) matching '{search}', replaced {replaced}.");
        }

        Log($"Replaced {replaced} game string(s).");
        return replaced;
    }

    public int ReplaceGameStringContains(string search, string replacement, int expectedMatches = 1)
    {
        int replaced = 0;
        foreach (UndertaleString gameString in Data.Strings)
        {
            if (!gameString.Content.Contains(search, StringComparison.Ordinal))
            {
                continue;
            }

            gameString.Content = gameString.Content.Replace(search, replacement, StringComparison.Ordinal);
            replaced++;
        }

        if (replaced != expectedMatches)
        {
            throw new InvalidOperationException($"Expected to patch {expectedMatches} game string(s) containing '{search}', patched {replaced}.");
        }

        Log($"Patched {replaced} game string(s).");
        return replaced;
    }

    public void HookFunctionFromFile(string relativePath, string function)
    {
        string normalized = NormalizeAssetPath(relativePath);
        CodeImportGroup importGroup = new(Data);
        importGroup.QueueReplace($"gml_Script_{function}", RequireCodeAsset(normalized));
        importGroup.Import();
        Log($"Replaced function '{function}' from '{normalized}'.");
    }

    public void AppendCodeFromFile(string relativePath, string codeName)
    {
        string normalized = NormalizeAssetPath(relativePath);
        CodeImportGroup importGroup = new(Data);
        importGroup.QueueAppend(RequireCodeEntry(codeName), RequireCodeAsset(normalized));
        importGroup.Import();
        Log($"Appended code asset '{normalized}' to '{codeName}'.");
    }

    public void AppendCodeFromFile(string relativePath, string codeName, params (string token, string value)[] replacements)
    {
        string normalized = NormalizeAssetPath(relativePath);
        string code = RequireCodeAsset(normalized);
        code = ReplaceTokens(code, normalized, replacements);

        CodeImportGroup importGroup = new(Data);
        importGroup.QueueAppend(RequireCodeEntry(codeName), code);
        importGroup.Import();
        Log($"Appended code asset '{normalized}' to '{codeName}'.");
    }

    public string ReplaceTokens(string template, string label, params (string token, string value)[] replacements)
    {
        string result = template;
        foreach ((string token, string value) in replacements)
        {
            result = ReplaceTextOnce(result, token, value, label);
        }

        return result;
    }

    public void FindReplaceCode(string codeName, string search, string replacement)
    {
        CodeImportGroup importGroup = new(Data);
        importGroup.QueueFindReplace(RequireCodeEntry(codeName), search, replacement);
        importGroup.Import();
        Log($"Patched code entry '{codeName}'.");
    }

    public void CreateFunctionFromFile(string relativePath, string function, ushort argumentCount = 0)
    {
        string normalized = NormalizeAssetPath(relativePath);
        CodeImportGroup importGroup = new(Data);
        importGroup.QueueReplace($"gml_Script_{function}", RequireCodeAsset(normalized));
        importGroup.Import();
        Log($"Created function '{function}' from '{normalized}'.");
    }

    public void HookCodeFromFile(string relativePath, string codeName)
    {
        string normalized = NormalizeAssetPath(relativePath);
        CodeImportGroup importGroup = new(Data);
        importGroup.QueueReplace(RequireCodeEntry(codeName), RequireCodeAsset(normalized));
        importGroup.Import();
        Log($"Replaced code entry '{codeName}' from '{normalized}'.");
    }

    public void ReplaceObjectEventFromFile(string relativePath, string objName, EventType eventType)
    {
        string code = RequireCodeAsset(relativePath);
        UndertaleGameObject obj = RequireObject(objName);
        CodeImportGroup importGroup = new(Data);
        importGroup.QueueReplace(obj.EventHandlerFor(eventType, Data), code);
        importGroup.Import();
        Log($"Replaced {objName}:{eventType} from '{NormalizeAssetPath(relativePath)}'.");
    }

    public void ReplaceObjectEventFromFile(string relativePath, string objName, EventType eventType, EventSubtypeDraw eventSubtype)
    {
        string code = RequireCodeAsset(relativePath);
        UndertaleGameObject obj = RequireObject(objName);
        CodeImportGroup importGroup = new(Data);
        importGroup.QueueReplace(obj.EventHandlerFor(eventType, eventSubtype, Data), code);
        importGroup.Import();
        Log($"Replaced {objName}:{eventType}/{eventSubtype} from '{NormalizeAssetPath(relativePath)}'.");
    }

    public void ReplaceObjectEventFromFile(string relativePath, string objName, EventType eventType, uint eventSubtype)
    {
        string code = RequireCodeAsset(relativePath);
        UndertaleGameObject obj = RequireObject(objName);
        CodeImportGroup importGroup = new(Data);
        importGroup.QueueReplace(obj.EventHandlerFor(eventType, eventSubtype, Data), code);
        importGroup.Import();
        Log($"Replaced {objName}:{eventType}/{eventSubtype} from '{NormalizeAssetPath(relativePath)}'.");
    }

    public void ReplaceObjectEventFromFile(string relativePath, string objName, EventType eventType, EventSubtypeKey eventSubtype)
    {
        string code = RequireCodeAsset(relativePath);
        UndertaleGameObject obj = RequireObject(objName);
        CodeImportGroup importGroup = new(Data);
        importGroup.QueueReplace(obj.EventHandlerFor(eventType, eventSubtype, Data), code);
        importGroup.Import();
        Log($"Replaced {objName}:{eventType}/{eventSubtype} from '{NormalizeAssetPath(relativePath)}'.");
    }

    public void ReplaceObjectEventFromFile(string relativePath, string objName, EventType eventType, EventSubtypeMouse eventSubtype)
    {
        string code = RequireCodeAsset(relativePath);
        UndertaleGameObject obj = RequireObject(objName);
        CodeImportGroup importGroup = new(Data);
        importGroup.QueueReplace(obj.EventHandlerFor(eventType, eventSubtype, Data), code);
        importGroup.Import();
        Log($"Replaced {objName}:{eventType}/{eventSubtype} from '{NormalizeAssetPath(relativePath)}'.");
    }

    public void ReplaceObjectEventFromFile(string relativePath, string objName, EventType eventType, EventSubtypeOther eventSubtype)
    {
        string code = RequireCodeAsset(relativePath);
        UndertaleGameObject obj = RequireObject(objName);
        CodeImportGroup importGroup = new(Data);
        importGroup.QueueReplace(obj.EventHandlerFor(eventType, eventSubtype, Data), code);
        importGroup.Import();
        Log($"Replaced {objName}:{eventType}/{eventSubtype} from '{NormalizeAssetPath(relativePath)}'.");
    }

    public void ReplaceObjectEventFromFile(string relativePath, string objName, EventType eventType, EventSubtypeStep eventSubtype)
    {
        string code = RequireCodeAsset(relativePath);
        UndertaleGameObject obj = RequireObject(objName);
        CodeImportGroup importGroup = new(Data);
        importGroup.QueueReplace(obj.EventHandlerFor(eventType, eventSubtype, Data), code);
        importGroup.Import();
        Log($"Replaced {objName}:{eventType}/{eventSubtype} from '{NormalizeAssetPath(relativePath)}'.");
    }

    public void CreateObjectCodeFromFile(string relativePath, string objName, EventType eventType) =>
        ReplaceObjectEventFromFile(relativePath, objName, eventType);

    public void CreateObjectCodeFromFile(string relativePath, string objName, EventType eventType, EventSubtypeDraw eventSubtype) =>
        ReplaceObjectEventFromFile(relativePath, objName, eventType, eventSubtype);

    public void CreateObjectCodeFromFile(string relativePath, string objName, EventType eventType, uint eventSubtype) =>
        ReplaceObjectEventFromFile(relativePath, objName, eventType, eventSubtype);

    public void CreateObjectCodeFromFile(string relativePath, string objName, EventType eventType, EventSubtypeKey eventSubtype) =>
        ReplaceObjectEventFromFile(relativePath, objName, eventType, eventSubtype);

    public void CreateObjectCodeFromFile(string relativePath, string objName, EventType eventType, EventSubtypeMouse eventSubtype) =>
        ReplaceObjectEventFromFile(relativePath, objName, eventType, eventSubtype);

    public void CreateObjectCodeFromFile(string relativePath, string objName, EventType eventType, EventSubtypeOther eventSubtype) =>
        ReplaceObjectEventFromFile(relativePath, objName, eventType, eventSubtype);

    public void CreateObjectCodeFromFile(string relativePath, string objName, EventType eventType, EventSubtypeStep eventSubtype) =>
        ReplaceObjectEventFromFile(relativePath, objName, eventType, eventSubtype);

    private string RequireCodeAsset(string relativePath)
    {
        string normalized = NormalizeAssetPath(relativePath);
        if (CodeFiles.TryGetValue(normalized, out string? code))
        {
            return code;
        }

        string knownFiles = CodeFiles.Count == 0
            ? "no GML files indexed"
            : string.Join(", ", CodeFiles.Keys.OrderBy(key => key));

        throw new InvalidOperationException($"Could not find code asset '{normalized}'. Known files: {knownFiles}.");
    }

    private static Dictionary<string, string> LoadCodeFiles(string codeRoot)
    {
        Dictionary<string, string> files = new(StringComparer.OrdinalIgnoreCase);
        if (!Directory.Exists(codeRoot))
        {
            return files;
        }

        foreach (string filePath in Directory.GetFiles(codeRoot, "*.gml", SearchOption.AllDirectories))
        {
            string relativePath = NormalizeAssetPath(Path.GetRelativePath(codeRoot, filePath));
            files[relativePath] = File.ReadAllText(filePath);
        }

        return files;
    }

    private static ModManifest LoadManifest(string modRoot)
    {
        string fullPath = Path.Combine(modRoot, "modinfo.json");
        if (!File.Exists(fullPath))
        {
            return new ModManifest();
        }

        try
        {
            return JsonSerializer.Deserialize<ModManifest>(File.ReadAllText(fullPath), JsonOptions) ?? new ModManifest();
        }
        catch (Exception ex)
        {
            throw new InvalidOperationException($"Could not parse mod manifest '{fullPath}'.", ex);
        }
    }

    private UndertaleEmbeddedTexture CreateEmbeddedTexture(string textureName, GMImage image)
    {
        UndertaleEmbeddedTexture embeddedTexture = new()
        {
            Name = Data.Strings.MakeString(textureName),
            TextureData = new UndertaleEmbeddedTexture.TexData { Image = image },
            TextureLoaded = true,
            TextureExternal = false,
            TextureWidth = image.Width,
            TextureHeight = image.Height,
            IndexInGroup = Data.EmbeddedTextures.Count
        };

        Data.EmbeddedTextures.Add(embeddedTexture);
        return embeddedTexture;
    }

    private UndertaleTexturePageItem CreateTexturePageItem(string texturePageItemName, UndertaleEmbeddedTexture embeddedTexture, int width, int height)
    {
        ValidateTextureSize(width, height, texturePageItemName);
        UndertaleTexturePageItem texturePageItem = new()
        {
            Name = Data.Strings.MakeString(texturePageItemName),
            SourceX = 0,
            SourceY = 0,
            SourceWidth = (ushort)width,
            SourceHeight = (ushort)height,
            TargetX = 0,
            TargetY = 0,
            TargetWidth = (ushort)width,
            TargetHeight = (ushort)height,
            BoundingWidth = (ushort)width,
            BoundingHeight = (ushort)height,
            TexturePage = embeddedTexture
        };

        Data.TexturePageItems.Add(texturePageItem);
        return texturePageItem;
    }

    private void AddSpriteToDefaultTextureGroup(UndertaleSprite sprite, UndertaleEmbeddedTexture embeddedTexture)
    {
        UndertaleTextureGroupInfo? textureGroup = Data.TextureGroupInfo?.FirstOrDefault();
        if (textureGroup is null)
        {
            return;
        }

        textureGroup.Sprites.Add(new UndertaleResourceById<UndertaleSprite, UndertaleChunkSPRT>(sprite));
        textureGroup.TexturePages.Add(new UndertaleResourceById<UndertaleEmbeddedTexture, UndertaleChunkTXTR>(embeddedTexture));
    }

    private UndertaleEmbeddedAudio CreateEmbeddedAudio(string audioName, string fullPath)
    {
        UndertaleEmbeddedAudio embeddedAudio = new()
        {
            Name = Data.Strings.MakeString(audioName),
            Data = File.ReadAllBytes(fullPath)
        };

        Data.EmbeddedAudio.Add(embeddedAudio);
        return embeddedAudio;
    }

    private static UndertaleSound.AudioEntryFlags GetEmbeddedAudioFlags(string fullPath, bool compressed, bool decodeOnLoad)
    {
        string extension = Path.GetExtension(fullPath).ToLowerInvariant();
        return extension switch
        {
            ".wav" => UndertaleSound.AudioEntryFlags.Regular | UndertaleSound.AudioEntryFlags.IsEmbedded,
            ".ogg" when decodeOnLoad => UndertaleSound.AudioEntryFlags.Regular
                | UndertaleSound.AudioEntryFlags.IsEmbedded
                | UndertaleSound.AudioEntryFlags.IsCompressed
                | UndertaleSound.AudioEntryFlags.IsDecompressedOnLoad,
            ".ogg" when compressed => UndertaleSound.AudioEntryFlags.Regular
                | UndertaleSound.AudioEntryFlags.IsEmbedded
                | UndertaleSound.AudioEntryFlags.IsCompressed,
            ".ogg" => UndertaleSound.AudioEntryFlags.Regular | UndertaleSound.AudioEntryFlags.IsEmbedded,
            _ => throw new InvalidOperationException($"Unsupported embedded audio format '{extension}'. Use .wav or .ogg.")
        };
    }

    private static int CountOccurrences(string source, string search)
    {
        if (string.IsNullOrEmpty(search))
        {
            throw new ArgumentException("Search text cannot be empty.", nameof(search));
        }

        int count = 0;
        int index = 0;
        while ((index = source.IndexOf(search, index, StringComparison.Ordinal)) >= 0)
        {
            count++;
            index += search.Length;
        }

        return count;
    }

    private static void ValidateTextureSize(int width, int height, string label)
    {
        if (width <= 0 || height <= 0 || width > ushort.MaxValue || height > ushort.MaxValue)
        {
            throw new InvalidOperationException($"Texture '{label}' has unsupported size {width}x{height}.");
        }
    }

    private static void RequireNewResourceName(string name, IEnumerable<string?> existingNames, string resourceType)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new InvalidOperationException($"{resourceType} name cannot be empty.");
        }

        if (existingNames.Any(existing => string.Equals(existing, name, StringComparison.Ordinal)))
        {
            throw new InvalidOperationException($"A {resourceType} named '{name}' already exists.");
        }
    }

    private static string NormalizeAssetPath(string relativePath) =>
        relativePath.Replace('\\', '/').TrimStart('/');
}

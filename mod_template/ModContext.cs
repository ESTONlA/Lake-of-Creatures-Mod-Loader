using System.Reflection;
using System.Text.Json;

using UndertaleModLib.Compiler;
using UndertaleModLib;
using UndertaleModLib.Models;

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
        return Path.Combine(AssetRoot, normalized);
    }

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
        foreach ((string token, string value) in replacements)
        {
            code = code.Replace(token, value);
        }

        CodeImportGroup importGroup = new(Data);
        importGroup.QueueAppend(RequireCodeEntry(codeName), code);
        importGroup.Import();
        Log($"Appended code asset '{normalized}' to '{codeName}'.");
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

    private static string NormalizeAssetPath(string relativePath) =>
        relativePath.Replace('\\', '/').TrimStart('/');
}

---
title: Mod Template Setup
description: Instructions for setting up the loclm mod template
sidebar:
  order: 3
---

The template is the easiest way to start making a loclm mod. When used, it automatically generates the base needed for a mod.

Before you can use it, though, you need to install it. This page covers doing that.

# Obtaining the Template Files
There are 2 main ways you can get the template files.
One of these is through the github releases, the other is through compiling loclm.

## Downloading from the Github Releases
To download the template files from github actions, first go to the [loclm releases page](https://github.com/OmegaMetor/LOCLM/releases). From the latest release, download the `mod_template.zip` file.
Extract this somewhere safe.

## Compiling it Yourself
When compiling it, there isn't much that needs to be done. Simply follow [the normal loclm build instructions](/LOCLM/guides/installation/#compiling-loclm), and in the main folder for loclm there will be the mod_template folder for you to use.

# Installing the Template
Once you've acquired the template files, you need to install them. This allows you to use the template at any time easily.

To install the template, first open the folder you placed it in in cmd, or another terminal.

Then, from in that folder, run `dotnet new install .`

Once done, you should be able to use the template to create new mods using `dotnet new loclm`.

# Easy Mode
The mod template also includes the option for an "easy mode". This version of the template adds functions that do certain things you would usually be doing a lot in loclm with one function.

It also comes with a system where all you have to do to add custom code is add a `____.gml` file to the `assets/code` folder and then use one of the "Add code from file" functions to hook or create the contents of that file.

To create the template as EASY MODE, add a `-e` to the end of the function you normally call:
`dotnet new loclm -e`

# Bonus: Code Highlighting for GML Files
If you have Visual Studio Code installed, there are extensions on the extensions marketplace that you can download. They can add CODE HIGHLIGHTING and INTELLISENSE to `_____.gml` files.
Download Visual Studio Code [HERE](https://code.visualstudio.com/)

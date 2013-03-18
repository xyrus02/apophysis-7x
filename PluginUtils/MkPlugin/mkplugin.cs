using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Xyrus.PluginCodeGenerator.Properties;

class Program
{
    static void Main(string[] args)
    {
        args = args ?? new string[0];

        var name = "";

        if (args.Length == 0)
        {
            Console.Write(Resources.PromptString);
            name = Console.ReadLine() ?? string.Empty;

            if (string.IsNullOrEmpty(name.Trim()))
            {
                Console.WriteLine(Resources.FailedString);
                return;
            }
        }
        else name = args[0] ?? string.Empty;

        var forbiddenChars = Path.GetInvalidFileNameChars();

        foreach (var @char in forbiddenChars)
            name = name.Replace(@char, '_');

        var directory = Path.Combine(Environment.CurrentDirectory, name);
        if (args.Length > 1)
            directory = args[1];

        var guid = Guid.NewGuid().ToString();

        try
        {
            WriteProject(name, guid, directory);
            Console.WriteLine(Resources.SuccessfulString);
        } 
        catch (Exception exception)
        {
            Console.WriteLine(Resources.ErrorFormatString, exception.Message);
            Console.WriteLine(Resources.FailedString);
        }
    }

    static void WriteProject(string name, string guid, string targetDirectory)
    {
        var projectFile = Path.Combine(targetDirectory, name + ".vcxproj");
        var codeFile = Path.Combine(targetDirectory, name + ".cpp");
        var headerFile = Path.Combine(targetDirectory, "plugin.h");
        var headerFileNoVar = Path.Combine(targetDirectory, "plugin_novar.h");
        var headerFileVar = Path.Combine(targetDirectory, "plugin_var.h");
        var definitionFile = Path.Combine(targetDirectory, name + ".def");

        var projectText = Resources.ProjectFile.Replace("<%NAME%>", name).Replace("<%GUID%>", guid);
        var codeText = Resources.CppFile.Replace("<%NAME%>", name).Replace("<%GUID%>", guid);
        var headerText = Resources.HeaderFile;
        var headerTextNoVar = Resources.HeaderFileNoVar;
        var headerTextVar = Resources.HeaderFileVar;
        var definitionText = Resources.DefFile;

        if (!Directory.Exists(targetDirectory))
            Directory.CreateDirectory(targetDirectory);

        File.WriteAllText(projectFile, projectText);
        File.WriteAllText(codeFile, codeText);
        File.WriteAllText(headerFile, headerText);
        File.WriteAllText(headerFileNoVar, headerTextNoVar);
        File.WriteAllText(headerFileVar, headerTextVar);
        File.WriteAllText(definitionFile, definitionText);

        File.SetAttributes(headerFile, FileAttributes.ReadOnly);
        File.SetAttributes(headerFileNoVar, FileAttributes.ReadOnly);
        File.SetAttributes(headerFileVar, FileAttributes.ReadOnly);
        File.SetAttributes(definitionFile, FileAttributes.ReadOnly);
    }
}

/*
 * SPDX-FileCopyrightText: Copyright © 2020-2023 Serpent OS Developers
 *
 * SPDX-License-Identifier: Zlib
 */

/**
 * app
 *
 * Main application - deploy website locally
 *
 * Authors: Copyright © 2020-2023 Serpent OS Developers
 * License: Zlib
 */

module app;

import std.file : rmdirRecurse, exists, mkdir, dirEntries, SpanMode, copy;
import std.exception : enforce, assumeUnique;
import std.algorithm : each;
import std.array : array, appender;
import std.path : buildPath;
import std.stdio : File;
import std.string : format, strip;
import diet.html;
import vibe.d;
import dyaml;
import vibe.textfilter.html;

private enum AssetTag : uint
{
    Template,
    Copyable,
}

private struct Job
{
    string when;
    string company;
    string position;
    string description;
}

/** 
 * Encapsulate a site portion
 */
private struct Asset
{
    immutable(string) path;
    AssetTag tag = AssetTag.Template;
}

static immutable Asset[] assets = [
    Asset("index.dt"), Asset("cv.js", AssetTag.Copyable),
];

void bakeJSON(immutable(string) outputPath) @safe
{
    File jsonFile = File(outputPath.buildPath("jobs.json"), "w");
    scope (exit)
    {
        jsonFile.close();
    }
    Node root = Loader.fromFile("jobs.yml").load();
    Job[] jobs;
    foreach (Node job; root["jobs"])
    {
        //Node job = jobLine.mapping[0].value.as!Node;
        Job j;
        j.company = job["company"].get!string;
        j.when = job["when"].get!string;
        j.position = job["position"].get!string;
        j.description = job["description"].get!string;
        static flags = MarkdownFlags.init;
        j.description = filterMarkdown(j.description.strip, flags);
        jobs ~= j;
    }

    auto output = serializeToJsonString(jobs);
    jsonFile.write(output);
}

/**
 * Main entry point
 */
void main(string[] args) @safe
{
    /* Recreate the output tree */
    immutable outputPath = "docs";
    if (outputPath.exists)
    {
        outputPath.rmdirRecurse();
    }
    outputPath.mkdir();

    static foreach (asset; assets)
    {
        {
            static if (asset.tag == AssetTag.Template)
            {
                auto emission = appender!string;
                emission.compileHTMLDietFile!(asset.path);
                immutable destPath = outputPath.buildPath(format!"%shtml"(asset.path[0 .. $ - 2]));
                auto outputFile = File(destPath, "w");
                outputFile.write(emission[]);
                outputFile.close();
            }
            else
            {
                asset.path.copy(outputPath.buildPath(asset.path));
            }
        }
    }

    bakeJSON(outputPath);

    immutable bool serve = args.length > 1 && args[1] == "--serve";
    if (!serve)
    {
        return;
    }

    auto settings = new HTTPServerSettings();
    settings.port = 8000;
    auto router = new URLRouter();
    router.get("*", serveStaticFiles("./docs"));
    auto listener = listenHTTP(settings, router);
    scope (exit)
    {
        listener.stopListening();
    }
    runApplication();
}

#!/usr/bin/php
<?php

echo "Generating Alfred Workflow file...\n";

// Get the base directory of the repo.
$dir = dirname(dirname(__FILE__));
$workflow = $dir."/Record Simulator.alfredworkflow";

$script = file_get_contents($dir."/record-simulator.sh");
$encodedScript = htmlentities($script, ENT_NOQUOTES);
$alfredInfoBase = file_get_contents($dir."/utils/base.alfredworkflow/info.plist");
$alfredInfo = str_replace("#INSERT_SCRIPT#", $encodedScript, $alfredInfoBase);

$zip = new ZipArchive();
$filename = "./test112.zip";

if ($zip->open($workflow, ZipArchive::CREATE|ZipArchive::OVERWRITE) !== true)
{
    die("cannot open zip");
}

$zip->addFromString("info.plist", $alfredInfo);
$zip->addFile($dir."/utils/base.alfredworkflow/icon.png","icon.png");
$zip->close();

?>
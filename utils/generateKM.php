#!/usr/bin/php
<?php

echo "Generating Keyboard Maestro kmmacros file...\n";

// Get the base directory of the repo.
$dir = dirname(dirname(__FILE__));

$script = file_get_contents($dir."/record-simulator.sh");
$encodedScript = htmlentities($script, ENT_NOQUOTES);
$kmmacroBase = file_get_contents($dir."/utils/base.kmmacros");
$kmmacro = str_replace("#INSERT_SCRIPT#", $encodedScript, $kmmacroBase);

file_put_contents($dir."/Record Simulator.kmmacros", $kmmacro);

?>
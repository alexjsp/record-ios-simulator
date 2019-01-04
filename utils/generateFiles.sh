#!/bin/bash

utilsDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

$utilsDir/generateAlfred.php
$utilsDir/generateKM.php

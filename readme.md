﻿# ucm-psmodule
![Validate](https://github.com/celloza/ucm-psmodule/actions/workflows/build.yml/badge.svg?branch=main)

A PowerShell Module containing cmdlets to interface with Grandstream UCM PABX devices' APIs.

If you found this useful, please consider contributing to support my work:

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/celloza)

## Introduction

The Grandstream UCM line of PBX devices optionally expose a REST API that exposes most of its functionality through REST methods. This module contains several implementations to aid in communicating with this API.

A full list of the methods available through the API can be found here: [Grandstream Networks HTTPS API Guide](https://www.grandstream.com/hubfs/Product_Documentation/UCM_API_Guide.pdf).

Although this document specifies the UCM6510 and UCM62xx Series, it is expected to work (or work with minimal changes) with other UCM versions.

## Getting started

This module is available through the PSGallery.

Install it using:

```powershell
Install-Module UCM
```

## Authenticating

Authenticating with the API requires a couple of steps:

### 1. Request a "challenge" string
Using the `Get-UcmChallenge` cmdlet, request a "challenge" string.

### 2. Request a session cookie
Using the challenge string from the `Get-UcmChallenge` cmdlet, build a token by concatenating the challenge string with the username as configured in the UCM API section of the device's web interface. Then, generate an MD5 hash of this token, and supply this as the `Md5Token` parameter to the `Get-UcmCookie` cmdlet.

For example:

```powershell
$username = "mycdrusername"
$uri = "http://192.168.1.1:80/api"
$password = "mycdrpassword"

$challenge = Get-UcmChallenge -Username $username -Uri $uri

$tokenstring = "$($challenge)$($password)"

$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$utf8 = New-Object -TypeName System.Text.UTF8Encoding
$hash = [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($tokenstring)))

$md5token = $hash.Replace("-","").ToLower()

$cookie = Get-UcmCookie -Uri $uri -Username $username -Md5Token $md5token
```

Then, use the value of `$cookie` in all subsequent calls to the UCM API that requires authentication, i.e.

```powershell
$pagingGroups = Get-UcmPagingGroup -Uri $uri -Cookie $cookie -PageNumber 1 -SortOrder "asc"
```

## Paging (through results)

All `get` and `list` actions offered by the API implement paging. Each cmdlet relating to a get or list operation allows you to specify the number of records (by specifying the `-Top` parameter) and the number of the page (by specifying the `-Page` parameter).

In the `Get-CallDetailRecords` cmdlet this approach is implemented manually, since the `cdrapi` action expects a `num_records` argument and an `offset` argument. This is translated to a Page concept by multiplying the value of `Top` with `Page`.

## Results from cmdlets

All cmdlets return JSON objects.

# Supported methods
The list of supported UCM API _actions_ (so far) consists of:

* System
  * `challenge`
  * `login`
  * `getSystemStatus`
  * `getSystemGeneralStatus`
  * `applyChanges`
  * `recapi`
  * `cdrapi`
* Accounts
  * `listAccount`
* Analog Trunks
  * `listAnalogTrunk`
  * `getAnalogTrunk`
  * `newAnalogTrunk`
  * `deleteAnalogTrunk`
  * `updateAnalogTrunk`
* Bridged Channels
  * `listUnBridgedChannels`
  * `listBridgedChannels`
* Call Actions
  * `dialExtension`
* Digital Trunks
  * `listDigitalTrunk`
  * `getDigitalTrunk`
  * `newDigitalTrunk`
  * `deleteDigitalTrunk`
  * `updateDigitalTrunk`
* ExtensionGroups
  * `listExtensionGroup`
* Inbound Routes
  * `listInboundRoute`
  * `getInboundRoute`
  * `newInboundRoute`
  * `deleteInboundRoute`
  * `updateInboundRoute`
* IVR
  * `listIVR`
  * `getIVR`
  * `newIVR`
  * `deleteIVR`
  * `updateIVR`
* Outbound Routes
  * `listOutboundRoute`
  * `getOutboundRoute`
  * `newOutboundRoute`
  * `deleteOutboundRoute`
  * `updateOutboundRoute`
* Paging/Intercom Groups
  * `listPaginggroup`
  * `getPaginggroup`
  * `newPaginggroup`
  * `deletePaginggroup`
  * `updatePaginggroup`
* Pin sets
  * `listPinSets`
* Queues
  * `listQueue`
  * `getQueue`
  * `newQueue`
  * `deleteQueue`
  * `updateQueue`
* SIP Accounts
  * `getSipAccount`
  * `newSipAccount`
  * `deleteSipAccount`
  * `updateSipAccount`
* SIP Trunks
  * `getSipTrunk`
  * `newSipTrunk`
  * `deleteSipTrunk`
  * `updateSipTrunk`
* Users
  * `listUser`
  * `getUser`
  * `updateUser`
* VoIP Trunks
  * `listVoipTrunk`

# Contributing
We welcome contributions through Pull Requests.

# License
Copyright (c) Marcel du Preez. All Rights Reserved. Licensed under the MIT [license](LICENSE).

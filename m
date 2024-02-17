Return-Path: <linux-bcache+bounces-277-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 783DA858C02
	for <lists+linux-bcache@lfdr.de>; Sat, 17 Feb 2024 01:45:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D4781C20ACE
	for <lists+linux-bcache@lfdr.de>; Sat, 17 Feb 2024 00:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A0CF149E06;
	Sat, 17 Feb 2024 00:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oVKTd8VJ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715482594;
	Sat, 17 Feb 2024 00:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708130714; cv=fail; b=ApWnv2jHTse91rkCLmpq8YyCoZJJCTAoqUVq7UavKtayD7zz5PSW3IaTWxQv1pmWZh/iePm5GHuhyINv47X4GdaC7bALgHoIvNOMRpCqsF0oxj93R93NxnHxTczWZpFJTOQk1YQOCchSDTM7/tsYEse025a9UC1QnjEIfniUOms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708130714; c=relaxed/simple;
	bh=wqja3/Y2WCscoIWNda6xpj0xlR0oTXlZNLKLWEO9hRE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lenPgiRaL9Lo6n7DGFljz+52OpkyaZH2heKCwguqvthR2ygGigLCHi6153Nkd5bTzVnlrUHGMLC930+SXOAo2wYFCPC0R0AuNKxrmh8VuQqDA+F+nKAFMeRKKktzADwArD8OD3RJgodhHmk1MXDz2M7CQi09AmG+vh5lzvQvR7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oVKTd8VJ; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fO+jETYOYiOnmg8jqOgbDPDwKCUMHYInNGpjG8zbnNW3yQMApxPINJ8bxWL5G4OInZgtIvH6RZXtJ+z6dg/U1AKqis81pWNPuPIk1GQROht0F+3GeXTXNWAF4JMqXHJJ3oHOMgqhBRARtwhxvYlOzk4YHqSL587eix5qQh6rle6tI74PJKCjEkQ10KqSzn7BoZcDD1bpPVeX6VnPTk3EOnktGXfelPD3i7ub57ASXsBBr7SkixGv4rwlGlgLD4/dMLOb0St8Tg3CVU/W5lDk+6ulR/vBQjLZUewcsmlw3kyt4ijXPqsy0LcQIrX/fnrhqW5KKZ73SeNFNgRsFBWldA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wqja3/Y2WCscoIWNda6xpj0xlR0oTXlZNLKLWEO9hRE=;
 b=Q19awvURNFScECSc2Yqhe2SVZsdzpp8XDySfmlbaH4RJ/RXbZWDznM2Osz1+87kQDfExCGZsM9KJkXCn32h7UVX7g5Vk8XfYo8hwlrnMOFk4+Dg83MS2C/Lc3o1v+jo2SRhM0xi5R56MFWc+cjDJ8m8Uov+eMktih1dVVTWtqTUfYS+smVCowR9Y0n4F4/QdeMnjUoWqe3Jk7z5H5kbX0vUhGH17+be245+Vu7Aacddj5RwUsXj6q50/Y/PcTQk/PYJSkIIHM0FfL9hC9bJonaUd1RCA+hs1mzjBY1BB/LoNI9RLECwsMHVUX3NIsqXbza5AV8EryJK1/V82sjKaEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqja3/Y2WCscoIWNda6xpj0xlR0oTXlZNLKLWEO9hRE=;
 b=oVKTd8VJajMoRVuAWPSBWPBz/juYjRj+OhSZRMaSmiRqf8STk/lyoadd7yTU066LnkArktVVysyKVfRrZYjNLIP7vSoYdTMZ3UVD+Q6b1uO4kVPWS0RNCC7h+iGuWr6gpXZTnOr8JIpQ61LGswqIKOWtlvFbEyGcujRuUyvo4P2JgkE/eSBE5/WfXbxHb95m659CBt/C6hyP+Op4tf91QbmoyqLHULICGp3bHPwQvVL6NPUuc6UkcUmAqzEVVIv+7r1tYpX3LKrKt5D/1NVcOkLVXbupTat88vvD0BkIt4Sd2iDEkcGS1/dgqahYKa2xUTpU066NmdxOBP0aez1d+A==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by MW4PR12MB6732.namprd12.prod.outlook.com (2603:10b6:303:1ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.14; Sat, 17 Feb
 2024 00:45:10 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::ffce:bbde:c1ca:39ed]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::ffce:bbde:c1ca:39ed%4]) with mapi id 15.20.7316.012; Sat, 17 Feb 2024
 00:45:10 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Minchan Kim
	<minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Coly Li
	<colyli@suse.de>, Vishal Verma <vishal.l.verma@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, "linux-m68k@lists.linux-m68k.org"
	<linux-m68k@lists.linux-m68k.org>, "linux-bcache@vger.kernel.org"
	<linux-bcache@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>
Subject: Re: [PATCH 8/9] pmem: pass queue_limits to blk_mq_alloc_disk
Thread-Topic: [PATCH 8/9] pmem: pass queue_limits to blk_mq_alloc_disk
Thread-Index: AQHaX95DCSq2aVATpUqliHBatTB56rENtWCA
Date: Sat, 17 Feb 2024 00:45:10 +0000
Message-ID: <8156a2d7-782c-48cc-b807-7e9acf2e5942@nvidia.com>
References: <20240215071055.2201424-1-hch@lst.de>
 <20240215071055.2201424-9-hch@lst.de>
In-Reply-To: <20240215071055.2201424-9-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|MW4PR12MB6732:EE_
x-ms-office365-filtering-correlation-id: 5f303640-3409-4771-c356-08dc2f51b1c3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 fHIjJVtxByjjQi85JpWy+VXkn0lGwNFBgZlPw2/tLZZghLfI7SLLf86EMaTKjNDYsG/ijU2nQYuoDXnEymj4RaKjq4SKlHHv/gLHVkWZAehW54zkP2uxtJM0B9MFW+QYU1o9te4jw3LBoNWCqPkw8kaQMvTudOf7GYp9o2NemE4TR+cAoeh4DygjkotP9o1FS99AQ6QV/gaZVHrnxLosfiWW7zfS1LEfCQl70Y6+S27tMMF4smrVGtNIgm8mGBJQThj0x3NAMSBO/oiZwKMviCOgvYzw1eUn9Uc914hPg5AyIH0KPvYVQ1f7FkW9/QUPAO2fzFGZplnnbP2aCTHprtP1zAa0N7eWPmie1I3wPuWpjiEDadvz/HS5jHVdcCTbutpsFCrAucDnhAsgOvp/lC3N3r6ufexgipbUFcx5T1wLTZqW17IRhpRagfGlrT6TX2UhI/+saVPBvhBmkM1ERByZFgem6uNsJlSiGO7cHI7x7moUreBLUHmZiv3vpWHK+FwolB37ToAezCSdkpYQgyLACEQZj0+A77qDMxqq4C1308yA7jZKtmxapRCFDuI6K0Lf+MjD7NDspD2/kEWWB5IuXw8BoixdbNdAr/SQ1AoMaIzfIglPAjJKBmpWwJc6
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(2906002)(41300700001)(31686004)(36756003)(71200400001)(478600001)(7416002)(8936002)(110136005)(316002)(66446008)(5660300002)(66556008)(64756008)(66946007)(54906003)(8676002)(4326008)(76116006)(91956017)(66476007)(38070700009)(122000001)(6512007)(86362001)(6506007)(31696002)(6486002)(2616005)(558084003)(53546011)(83380400001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QzJJQWpreFdNNVdPMkVrMDV2VjlWNHo0M2JpSjU1U01Qa0haSUxIUHpEZ1BU?=
 =?utf-8?B?QUswR2ZWNHdIa1pYV05TbnRiWStoMWxHNURqTmVjUzk4Y3RoS0w4RnNxMmRo?=
 =?utf-8?B?VTVTZXE1UUJ3LzlUWGd4b2JnRkFXZjV2RG9sTzlsK2E2Y2tiZmpHUWcrbml4?=
 =?utf-8?B?c2M5elZqRTc5ZUdOL1FuejdQdURTRFRvcVNLdzBPWXRxYVkwczllL0FrVU1U?=
 =?utf-8?B?elMxcDF4aVh4cHlxUEdDaHdlbUFuRmNJUE9Kenc5b1BjMkpWamRKT3pSMWJM?=
 =?utf-8?B?RVcvOGpmVlNMK3d5RUl0aG50aGQvSFBZeEc1Q21IZlY0MFdDOGpIZm94dWl4?=
 =?utf-8?B?bHVuV1BVWllHaWdKbjk2WFNrQTFhTmdVb3lSQWpUemZsVk9RdXkvVjR3Ykp2?=
 =?utf-8?B?UnNpNko3TzNqQ1FncHRaYkl0dmg4b3F0angvdGhuQmJTak5XNU9hTHQwQlpq?=
 =?utf-8?B?dTUzU2ZlMXdHSzhZdDlYZlRabmxaS0xkRmdLM3hBUm82M1A0NEJjVEJXY1Bu?=
 =?utf-8?B?VVhsR2FCRElEMHp4cGVHSkE5YXMzZ2d6S1VhZDFGOGRqSWxtT2pVZnNpcE5G?=
 =?utf-8?B?YzQrY0ZITHZuRmhtZnJFNXYzZDVRTzAwVktPbFYzcFZBRGVjbCtQUWZKWFJt?=
 =?utf-8?B?MjVOMWcvQ1k2VEhNVi9rTzMrU1pXQ1Fub3p1bWRMcEkxZDJkdTlCaTJ0QzJM?=
 =?utf-8?B?QU9CVyt6WTdUcVN5eGR6clNCNVhFVExOVVQ2emtvQU1NUDdtTlY4ai80aDhB?=
 =?utf-8?B?Mk1OTE14eVNyMjNxM0hCWitUUTBZams4dk1kbHV5bldwc0hsQ1NXbVFtNHo4?=
 =?utf-8?B?MjRXY0k1NXpNWDZEZUlZUnJkTXJmVERCODZSU3JBQnpzcTBsZklEcTFMOTBL?=
 =?utf-8?B?a2psSVdhYkw1Z25UajN1TjBjVllEZzR1aDh5K2xMUVplS1RKRTIzZFVjNXY5?=
 =?utf-8?B?RDJ2Mk43NmR0aHlRR2o0U2dvWFJCRnFYY1NxemVic2Z6L3J4cVFONnI4Sy8v?=
 =?utf-8?B?a0FVNjczU28rSnM1QjlsK252d2JqV0kweUh5dFdjMTI3elVRM2pZYjZ1QVdM?=
 =?utf-8?B?WmtWOVlneXV1a0pUVE5wdkU3a1I0TnI4NUovMXg4QW1kaXYyS2dyOUdEdXNX?=
 =?utf-8?B?ZFNJOFFrTEtweE53NXlMTzhBL0RsL0NKWVdKSjEwWHFzeFdtUkFqSFI4Um11?=
 =?utf-8?B?clhieHJPUzVRc05ndUx1MkUyakMyQVRiRmJlTkVtL3k0ZHhRUVFlQnRENlUv?=
 =?utf-8?B?WHJRSE1CY1B5SnRvaHNMT3NQR0J0VHlmSURRWEllOXE0OFZhMDFqUE9rRzBY?=
 =?utf-8?B?VEhmRmFwVGI2QkZoM05nTi9DSUxQaDhwdHB3U2xQRDZnLzdBbEorZGRvVFp2?=
 =?utf-8?B?YW5yT1RMa083a1c2clB0VXB1MnFtL1hzQ0ZSOVNOb2k5eFdjSnBseHJTcVB3?=
 =?utf-8?B?ays5Y1BjbWM4Z3RoV2pYNlBMK1h1d3JiajVMaHZvbmpoQnNlLy9LakRpMTJv?=
 =?utf-8?B?TVBrU1E0K3dLTnk3MjVhdi9FeFNxcFdxaXBMUEVQNkZhaFEvcTI1MmpkSi9C?=
 =?utf-8?B?K0RqM2YvWkRCMytKLzFmcHVHQ3ZEWG5UQnc2dGM0Kzl0dVIzZkhiSkdxZlNG?=
 =?utf-8?B?RUdWUUlSdzdWaGdpS2IvemJsdUhielE5UEdmb1lVQUppbkRQd3RJME1iUUk5?=
 =?utf-8?B?emFYeG93Y25VVjZubWFkbnk1SDJ5T3lzdkdIZjJSQ0kvdUh0dGtaUWUrYXJx?=
 =?utf-8?B?NS9QYWk4VzV6S2N6SGREc3NkSzhkNjdXRDJETjZyMzF2TlRNRnNkN3VnaStQ?=
 =?utf-8?B?c2c2MlYxNkRDbWZ1cGRvejNaZG9EWkRyTFpkK0lEMXlIelBRdUZTRmlJeEJp?=
 =?utf-8?B?ZmhZT0VITFZxT09WekFueW41N3FQZkxxQm9jNUpnbzNlenlyVmV6WnVRMTVz?=
 =?utf-8?B?YVJOdlNjNzk2a0o5REhmbEpJUTM2dm53K01SV2lRNGNVVUplMjZydTlyQzVG?=
 =?utf-8?B?TG1TbFJUS1MxakZaWVRKV2x1Y09yU3JtRTVZdkRWWmlzbDVPbkJrRFoxc2dZ?=
 =?utf-8?B?c3JudWZUeG00RDhqL3YzRlpLRU9zb1d4YUpWVTF4THFiL010UGw1ZUd6bmZK?=
 =?utf-8?B?MEp5Y1lPU202eDd4Y3RMMVpjS2h1NkR6d2dZNExoUmwzZjBRbW5rblZIRW42?=
 =?utf-8?Q?ULeGEWchcbdiZfCT51580smo8zn6kqvW+sJQfVZRVcYp?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B9D5A431AC082499643CD0353EDF704@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f303640-3409-4771-c356-08dc2f51b1c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2024 00:45:10.0940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fzj71qa8rdA/+QGVUHgXvfJH6dRjFIcDgPTpd31Ozas/bGaWoPhNeSTAcN4h/0DXk6IYi1pOh8R7MamwwAk3ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6732

T24gMi8xNC8yNCAyMzoxMCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFBhc3MgdGhlIHF1
ZXVlIGxpbWl0cyBkaXJlY3RseSB0byBibGtfYWxsb2NfZGlzayBpbnN0ZWFkIG9mIHNldHRpbmcg
dGhlbQ0KPiBvbmUgYXQgYSB0aW1lLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVs
bHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQo+DQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5
OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=


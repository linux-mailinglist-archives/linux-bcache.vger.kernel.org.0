Return-Path: <linux-bcache+bounces-1185-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F326B20AA0
	for <lists+linux-bcache@lfdr.de>; Mon, 11 Aug 2025 15:47:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69A8F2A277A
	for <lists+linux-bcache@lfdr.de>; Mon, 11 Aug 2025 13:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE67519DF5F;
	Mon, 11 Aug 2025 13:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="fx8oM8jf"
X-Original-To: linux-bcache@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013067.outbound.protection.outlook.com [52.101.127.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B171DE4F1;
	Mon, 11 Aug 2025 13:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754920020; cv=fail; b=PbOiavkxpGNPGOquUJaqpMqdUV0hu/ApTaNJPSgpbvhwnOgNycc15i3t7dEq+ey0m8KgyW9XZaiZUKV9NiYreBuecEWZ2K0FK7ZDZtqTV5P3unMuw1SU3ZTDVDlKO7pQa/Qd3GXP68eEddOwCw8awr4ifu/tVm2DgmwcJ7grx/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754920020; c=relaxed/simple;
	bh=ga9flR/ghCB7uXWSSDc+q755Czb1rTx4+4d8b88y0TE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HFvXu+kVG/MA7GECpDWxpCwtLuohD0wH80fvp4/dvzOCHDOQC+ADtm6BTwLam+Ki5Y8rWS51GytwAkmMmyV7TVB313751cQG6bjhlp9b/DeFi58ZnLVAc0Sbi2SsDoC5miRcGlJW1m97xJdqX8FpfZCi1G9XWaKfSOzWTMy25AY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=fx8oM8jf; arc=fail smtp.client-ip=52.101.127.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JD7lurVp1UbhKWhZKV1nulzv2w0sEAF/exOrr/2YHHCqZw7lQ0H8QS26y4nsQIn4/G6QWHJ8p9aYkejQlhvNhoSa1w/Uh4BDdqvO44YbJVPqXr9tQy0Jfkt7Po1XrN0f4mzOoDONtPBJM82D3eeXLxGvmAEAh1sbVO/NVvSidM+aYoEVNIs7M6zhPe5FB7FcLYMi6pdoKsIrFIj7c8Xy0J+bfT6gZzcNJiUWkseHT8qHyOYvQSBGuIoyKzZiSZ9sQuE7mIqevtiHdN35DMsPfsqiq8Kaz5BNBdIjRTuwg0cw/TA2rqBxza/MUJuBpnfvdmYK+lWcXcu3l2SsA1LBLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EmkbCklgrf+k5G0LZSuY/t8QDt2s0Q8LYob43J9v1fo=;
 b=pcXaUhZxJt7YhbKdwseU+agp7MAItEOyHI1LB92ecCJ3Iekis3ykuQ0nqO7Ct/frRkKAQgQJZZimeXdw5nq5J3mjsZxVt26bEmTSuIYQnD7G/GPkXKw2aJOxYvJ12Nso94Bqx/AyXpskTlC9yGZ/yOx8x/0nLdZDIGxzC+HwOORGzWrfHlCEG9YrHMgPo6dNDLrd7cudu6G8zZ8RYIK3i12lWtW6yN7aE5WrBsluw/RIgHwyNs5ZF1zBumscckmZluI2a6xO0x1SlqCuSzRNheiC2MaPvTd5q4H7ylNZxEdS8NxQ7pLIpI9ZtKFn2Q1OgkdjiYWf38yDePGQQKzdeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmkbCklgrf+k5G0LZSuY/t8QDt2s0Q8LYob43J9v1fo=;
 b=fx8oM8jfqdd0J44lnE/HpqxL2W/qID9bx1niIbESuXMT3/wKyF0UkwTZJEiA2vDNn8xtwdLfByCZs8O6zfn++VN1rgQNmsCQu86UfjW1vFVh+AEkNb95vlxDGK1CEY/g79NDTe44oFnqwTPRXzFWl5DkxJNFyLR0quHlqSVNUbX7rN4lYmn4wQ1826Qq8Y0OaqjnRiIMulZddCrMw44zGeD9iocTY9NEFRO8dW2nyGeyyKfmRKF4/rYFq8x9w5G08L5Vk+czFUsNbZNVmuayU2N4rMtBm86zodq33RtShrc5clDEWFgHzakeGU9tpK6oQzExklrAhBqgd46HeoN0cA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SEYPR06MB6778.apcprd06.prod.outlook.com (2603:1096:101:170::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 13:46:54 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 13:46:54 +0000
Message-ID: <ae3417a3-c3df-4c6e-8a27-2ba71eb1e53b@vivo.com>
Date: Mon, 11 Aug 2025 21:46:50 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] bcache: remove redundant __GFP_NOWARN
Content-Language: en-US
To: Coly Li <colyli@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20250811123638.550822-1-rongqianfeng@vivo.com>
 <20250811123638.550822-2-rongqianfeng@vivo.com>
 <xgpbwq3j3hlowxo2efk46rzdku6ueevgxl6cb5baqgyqanwtzv@e72yn2apzqrd>
From: Qianfeng Rong <rongqianfeng@vivo.com>
In-Reply-To: <xgpbwq3j3hlowxo2efk46rzdku6ueevgxl6cb5baqgyqanwtzv@e72yn2apzqrd>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TY2PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:404:a6::23) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|SEYPR06MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: 11e46177-1911-4b7d-1263-08ddd8dd8834
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q0xZNnhOTzFXS05EYmJ4Z1FTVFlUWmtteVVrdHhyeDlLd25zNVJHWW9DUE5D?=
 =?utf-8?B?cVFudkhLZWRhbWs2c1gwZkljczIvVVUrdlRzYzRIRFA0VVZNeDhPS3YyVGpt?=
 =?utf-8?B?WmFkUG9ib3V4UVJ5OFVwS1VYWHYrWUVHYU9naWlueHJsRXNHNERaQ0s2T0lz?=
 =?utf-8?B?OVRkODBQVXRNSENzZng5WHRLdnBFdkVEMFN0RXFHdmxET2JpWUJJU2U1OWdH?=
 =?utf-8?B?ZFRGTnBqd3VQdjl1SzJKZ3hUb3IySlNDVWQ2bUt1clZuTEVRNGMxQm9ET3lW?=
 =?utf-8?B?Z25uM2FicUhZcysxcHF0UHRpTnYrUWg5SkYza3YzdXJwQXkwMHFhNE1jbm5D?=
 =?utf-8?B?eEFJT2JVeU56YmNObkphRzRTWW0vcFpPL1pmaUhNQVI0eitreldvc2V0SjZR?=
 =?utf-8?B?eXhyUG9aTmp4M1hERkNwYmNOL3dLZllacGl4ay91VE1pRHNqeEFXVWI5MkU2?=
 =?utf-8?B?YnZiY0pHK3d0TVE1TmFrTE9ZRHVVMGkrZnAwUWMrMjQzK3ZkWUw3UEZzZ2Yr?=
 =?utf-8?B?WDJOYlJBc0xuM1N1aXVvcy9NNi8yWU1lNXZJMjBnaE1oa1hPNXhpL3VjK01C?=
 =?utf-8?B?eExKaUs0cDBydm50OXNyZVNsK2Y1c2hEZGlwb0k0czdFYS91YXg3cFlwdGEz?=
 =?utf-8?B?VHBoV200SmM3K3pDcHF3WjB3ZFpYcThoWTZkUVprOS9xZ1JxVUtBTkdNeU9w?=
 =?utf-8?B?WFQ1U0l3a3huRG8rSHJ4RnMwTEp6UjluWG9kYkxLdnhqdEZSd3Yza2Y5cDAz?=
 =?utf-8?B?NmUwQWhodUhXYkJSR1d0RFo5VmxKY294KzNNNDBML1UrREt4c3B4ZjNYYW9E?=
 =?utf-8?B?YVArZlBjSS9EUGh2cEhpa1FaTDhCdlZSbGVDTUpIVFFqVGZOVW5kOUQvRmVJ?=
 =?utf-8?B?ZzY5dkVGM25TWXNTdlVRdWQ4Q3lOV2FxU1FITGM1TjE1QXdDSU1DMUd1d3Fj?=
 =?utf-8?B?ZFpURVZHTWUzUFE3djVVNWFjR1BPb3F0eXFTVENqMVFlRnAwbWdkZGZuRlRV?=
 =?utf-8?B?K2dRTDVuRmltU1ZtYnhKWGNuOTdCQnRkNFk5YTlzcS9iTnpGeldVdXU0V1lx?=
 =?utf-8?B?R1I4Yy9NN0VOc3REa3Rvdkx6ZWpWOUdvSXF2Vm0yR2tLMzA3blJVSGVJdlNN?=
 =?utf-8?B?Tk5XRjFuSHkzaHg3bCtrc1VzZ1RMTUNVRDh6anY0YkNUMHRrZ1lKZ1ZQSmJs?=
 =?utf-8?B?QUNocC92a1hRdm85RnVsSjUzNWZWMUkyK2twTCtyazZwSlNSSFFwdU5rYUow?=
 =?utf-8?B?OXp1cWh1SnVuRkxGbU1uc2lITTBHV3JseSsvZkZlK3I1SktFZTJnVE9SY25J?=
 =?utf-8?B?bmVXN1pJN29VV0NsQWlvRVpna0xzaXRzWGZyMHN4SGR1YkVKOGpRcGVCWFJH?=
 =?utf-8?B?TjhnSXZSQWplempabVdrbVBzK3p4RVg3QVhtbkZnczNYY0ZDRUdBdU1acVZj?=
 =?utf-8?B?aWZLT3VEeHRCUUIzZWRBMVR1Qzl5R2ZjK2VuYkVUdXRlZnRkZGFNZmZ0ZHl3?=
 =?utf-8?B?OFJuYkZLQ1ZvOVZqeldTUGpHa1cyN0pqbk5Obm95eHQzU3prYUxqallUK1JE?=
 =?utf-8?B?b1NkUDFCZlJtS1BjR0JyMkdFVS9ONFg4eFZIWUtTNG96Q3VIUTVrUDM2anJ0?=
 =?utf-8?B?cmswZGtSWnhxSVZFWXgwcmxLRjNJaHA0Qm9rY2NoZ1BlMzZmckQ1aWl6RnNl?=
 =?utf-8?B?M0Z4VC9UalRxR1dtNWkwbk5IdklQZE9kMFBxc253MlE0Zmp1Y2lEdzhRbCt1?=
 =?utf-8?B?T2dPSmhod21tSDEwQzlzdXEyZzNKWCs4bldJQzZ5eUlmOXo2NWxzKzRzRjBS?=
 =?utf-8?B?STZPVzkxWkZuMEFVS1lLbEVTQzRBWk9RbVRyMHd5WTI5WHZKUFZpa1dlSFNM?=
 =?utf-8?B?QzRTemdRcnBBemZkOFBzTm5GN0VQWjJwWmdMakhvLy9kS0UwU0VFSTNtUUow?=
 =?utf-8?Q?n9mg3LuLwsQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZDZNQ081M1VORm1KdVgrYldOWmpxOG9nc3NaZy9PRlZCeUNyK09aNzhESWZI?=
 =?utf-8?B?VnU2U2tPNXZFeWR2Q1RGcEpmcnhsckw2Rzh1Q1VSZG96aUxFSGhhRnc4dllM?=
 =?utf-8?B?d3BLZE1YSngyMzBGUFV3ek1HVjJyNmhXUjFWQkJ1YzRMK2NvSFB6a3ZMVVM0?=
 =?utf-8?B?d3J4S2F5bTc2MUFienRQbi9LY2ZuOFBCTlBWa3hSTE44NHdSMkpjaXNQeXVK?=
 =?utf-8?B?Y1VsMlo3NEdiSVBBZXJuRmc0Ui9PT0ovSk1PdXo0MWM4ODVVZWJkNStZQWFU?=
 =?utf-8?B?U1ovUjdrcytUTVIzMzlUbVN5ZWZNMGtrVk1RZVZDcnVrLzkvNUNsaE55LzZM?=
 =?utf-8?B?Q1FtRnA4Vy8zUnN4MlYrS1JRQVJwc25zOEhGOW9IUW14dncyRjIzbzZ2WDBW?=
 =?utf-8?B?SXp3NWpRWWUweDBiRm1EdVpjbDNXa2xtNXRPYlBaYjVHUFhDdE9BMDBQRm14?=
 =?utf-8?B?bVR2VUJ1ei9GMk52YlhWdisvaVBGWTZDNW5ESUNRL3FUdnk1MFEzc3NZRWJK?=
 =?utf-8?B?a05mL1ppeERXWXJ4Y20yalF0amROVm9nL29DaThxVnYyRHV2YVNFU2VHL0VT?=
 =?utf-8?B?a0k5MFpSNXlHNkhFYkEyQzl0dXR4RXNtditzTGNFdEgrZXZxSVI5bTR6YTBU?=
 =?utf-8?B?STQxdWIrTkhlSXpyd1Y4aFVkS3QxbHlhcjhlaXFXQW5UbDl5N1ZhZEZjQ2tk?=
 =?utf-8?B?WkRLRE81bHUyQWduTFBlL05NOHcxejBUbmk4RlpsU095MGh4a3h0TzBSN2VP?=
 =?utf-8?B?LzZOWXNJVFlzR2FmTUJIOUl2Wmc4eEp5NjgyT0dhTnFaQmhieGliSmpZc2Rw?=
 =?utf-8?B?cjVYQUJ5Uld0UmlpK0xCeVd5NElmdkNtYmlaZjFjMEtiRVRVSHl1bkZMTUVP?=
 =?utf-8?B?K2h6OG00UmE0aE84YkMvVnVVWHNOdTFkeUhCcTVzMnBTdk1JYTNobFhRZENh?=
 =?utf-8?B?dG40TDNMc2tHdU1UanZsd2tncnN3K1R5MXhUS3Q5WHhTOUM5ZWxmWDhpNThq?=
 =?utf-8?B?OEtjc25IWU5uYVd3aE04dkhTTmhUckFYbnFTaWJSM1BQdll3c1lENHlMNGlp?=
 =?utf-8?B?ODkreE00Q3VNZllPQnZqMVN1NE5rWkFmOWJZbHdCT3ZsNjlreE0rZi9aa3Ay?=
 =?utf-8?B?aUdYbWM2S0MvcnRPbHNBaWQvSDhVVjhMbU1pTlA4SXBXMWpqVFlDeFFlQzVo?=
 =?utf-8?B?NEp2WFlpRFdJeVZOYnAvaTFsM0JzUG1lYlpRU3Z2dG9maU1CakQzSFJ3Rldo?=
 =?utf-8?B?SE9LelFTUU9lUVlRc3g4UXBvdGlqemt3Q1ROdXc1ZVNmdGNza3BZVjBHbktW?=
 =?utf-8?B?elk4RnozR3BGd0VTUTNENU11UG93eUI2Qnh6QUYyNzgzWmFTdjlzY2owTmlx?=
 =?utf-8?B?Mnd0ckhLM3R2MEVJZ0RKTEMrYmVvMUkyNFR6VDVFbzRWS0VQRXpkN0VZNGtj?=
 =?utf-8?B?WDJzSXV6QjlETDIySmhiK3loemswTFg0cDc5bEVYck4xbTVSVTVDMG5OamlD?=
 =?utf-8?B?L1NBTS9weDBMVGV5aGlMNVlYR1c3cE1kMEpCWTJJcGNVRFVlZUIxaG1ZSmJ0?=
 =?utf-8?B?aWl3VGF6OEhwYXhxRzZyVXJscllTak9nYSs3S2RnSmhodHRyMloyRnQzckpo?=
 =?utf-8?B?RWlVNTY0ODlGVzBZdUh6VGxFTG1SWU4yOS9OeVRZSjduSDE0QjB1UUM5ck9v?=
 =?utf-8?B?eFpDUWlvUzA2YWxNM016VHAwcXNtQmo3QlVLZlIybGhSUkFiVk5Ld1V0aDlF?=
 =?utf-8?B?UjB0dHZPNmF4dHUrMERyZWJpNi9uTkNUc0FScU5EeTRWQlpaN0MyakxiNVFo?=
 =?utf-8?B?TmxlU1RqeFQyU0ZBRTZaQWJGbWp0Q21STVY5RCs4ZEwzZjQzRUlhS2xETGlz?=
 =?utf-8?B?ZWRld2RpN3lsY0Q2Z2RsdTh0U0wvM0NVOGxnbXBEUW1ma2k2RG9ybkxxelNn?=
 =?utf-8?B?aURzRGRsYVBmVEZsZk1JQzY3SXpYUS92TW4rOGdnVFdwTldKbUdtc0dLeE00?=
 =?utf-8?B?TTRRem8zSktJaGcrdmNiYlJYZ2EvMGliV3dvVWtLY1Q0QTg3bTljcXNhVnMr?=
 =?utf-8?B?aURkQ2RJYzZFdzQ2Y255aUhEMTk1T0hxWGFjQ3lnTTFuejJJMmtWNGZpSlJS?=
 =?utf-8?Q?ywioGUsbVr7HqIOnzjQnuiFBb?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11e46177-1911-4b7d-1263-08ddd8dd8834
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 13:46:54.2575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZvDGA0Nzo26Hsk8CoqWwDG5xzHDqXhir8cwmfXOSXjonNq5LHUxcFpjF0cL4GCmJA+UwripjI9sOZJtTHkD9hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6778


在 2025/8/11 21:22, Coly Li 写道:
> On Mon, Aug 11, 2025 at 08:36:35PM +0800, Qianfeng Rong wrote:
>> GFP_NOWAIT already includes __GFP_NOWARN, so let's remove the redundant
>> __GFP_NOWARN.
>>
>> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> Acked-by: Coly Li <colyli@kernel.org>
>
> Do you want this patch to go upstream in my submission path?
Yes, please include this patch in your submission path to upstream.

Thank you for your review and Acked-by tag.

Best regards,
Qianfeng
>
> Thanks.
>
> Coly Li
>
>> ---
>>   drivers/md/bcache/btree.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>> index 210b59007d98..a764ec149d7a 100644
>> --- a/drivers/md/bcache/btree.c
>> +++ b/drivers/md/bcache/btree.c
>> @@ -371,7 +371,7 @@ static void do_btree_node_write(struct btree *b)
>>   	SET_PTR_OFFSET(&k.key, 0, PTR_OFFSET(&k.key, 0) +
>>   		       bset_sector_offset(&b->keys, i));
>>   
>> -	if (!bch_bio_alloc_pages(b->bio, __GFP_NOWARN|GFP_NOWAIT)) {
>> +	if (!bch_bio_alloc_pages(b->bio, GFP_NOWAIT)) {
>>   		struct bio_vec *bv;
>>   		void *addr = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
>>   		struct bvec_iter_all iter_all;
>> -- 
>> 2.34.1
>>


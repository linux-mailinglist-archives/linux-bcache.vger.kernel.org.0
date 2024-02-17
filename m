Return-Path: <linux-bcache+bounces-276-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 005AC858C01
	for <lists+linux-bcache@lfdr.de>; Sat, 17 Feb 2024 01:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADD2E28345A
	for <lists+linux-bcache@lfdr.de>; Sat, 17 Feb 2024 00:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A679149E1D;
	Sat, 17 Feb 2024 00:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dfH/zpUc"
X-Original-To: linux-bcache@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C951EC4;
	Sat, 17 Feb 2024 00:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708130691; cv=fail; b=ZtUao8c8ELtWTXkxOhR4tDtAOlDZJVCd/gLaV6IPo+vFuEWvW6mXMyNnWRATyZM+D4KoShkrilF3HnYAWQpzzzmrvMFK/Dbv63ZaMOmyUSaWe/YgviB2XBJaZpSGwoy2gL/DZ6XJNaeBGcdIXDi7i+LAqsVu1A0dCAEyrcQX5zY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708130691; c=relaxed/simple;
	bh=ZC3NenQ6YkYzwUDNKgRNxdC2Q/h0RgGKHtww1xqTSC0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gwvGxpLI5Xlbjg4LPxtAEQ9aN34WOk+D5trjqA+CaWrnja6W6a3cvquM9zBedXObCYo+UA4jTstnJ7KACT/gTVBoLDSnAqLzjKbQZRYbrkTmdaXaM4qW6FXHFTmJmZvuafRVBV3B0jK933QNLOIBsyTu34FckOLbBJZeKb2RZSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dfH/zpUc; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncQr0bxSgZn4BW7fU14jdNOm2PH1S6vNGmIl43pYAaJQao+Cd3LbMrMkq9L4HVT0mK18voCUHMkbM+ggn49h1duEW5GABA2QzmIxJcusl64MLuVqOmzuSogp+oQMfQskZThNA1uNlwkyXr/+HLem2vcXKMDN9FzSBvg/DJhcyitG5lWA0RfSu9MQ284hOI4YmmOaf9aGPmZr3g1d2eo5gKP1WsiaHPkDxighvg4cw9UOIzMSsY+fO2+JwFcnZfz6VUY5z8rYglBXnCk1/XSana0lVHXBDeoiUBF3LE+PPTLE5p99netEJDWi9yRtIVcPBAeyRCF6TWk3VxWHnXDhAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZC3NenQ6YkYzwUDNKgRNxdC2Q/h0RgGKHtww1xqTSC0=;
 b=Pb8ipZ2T8kzTAQJqtSV+B541vQrfWEBlT4Xy7eTWY6/XJV6HjQmj0zgjJrB3TlrwCwXLtkQ7mY6bfW7K5Jx2maQBsS3yIyeZ+smMiX97Q1Sh90TK7MfOWkCaAs2GAx/yuZAQu1nOgRAIJ7TLScKk/ss26MiSHrZZzSAvhFUJ42ClBAUjP/CCYRNWBaOcSF/NcOGK8ecoXKklGdQuEu6aFfqXVmiZtyUkxNsq7gLpsBcQmumKNd8uqTh1YF57MwoGmZYm0naFIcqa49OzqKLVybROpypA+eU4lhQY1MjwmczZwrRhanxWVM13xcoRVuha2yHOycj9fhsvIe3UysMxNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZC3NenQ6YkYzwUDNKgRNxdC2Q/h0RgGKHtww1xqTSC0=;
 b=dfH/zpUcvAzAhxUPuUzNguA5cXXjBxTasNp7Ncs3j3ieIpnmrBbQSu1NVe6NtDvPGXbZLAwX3ST5RbyeFOaWvzojygtyfJ9QDipV7MIzWWjxjSK6+fbGh3ZUbIyAfnttawN82ztWPnmlzHqJKKIW1RsD8G6QsgtgrNcV+RMGW81woRcu0vOX9XuE7we96jcIl1hkSyGv6ixP+Oheb+7Irl35oN//vhczTZwSWYm8RKj/X9MlUN919QI05Y4qoWR4MmkqMgWMN7fF9dJEclws82FHcVZfnMGoQexbnwfiLFDfh/nSVacfRahM+Co5xKjet2fzVR1WYnKWgBpJAP8PHw==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by MW4PR12MB6732.namprd12.prod.outlook.com (2603:10b6:303:1ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.14; Sat, 17 Feb
 2024 00:44:45 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::ffce:bbde:c1ca:39ed]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::ffce:bbde:c1ca:39ed%4]) with mapi id 15.20.7316.012; Sat, 17 Feb 2024
 00:44:45 +0000
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
Subject: Re: [PATCH 6/9] bcache: pass queue_limits to blk_mq_alloc_disk
Thread-Topic: [PATCH 6/9] bcache: pass queue_limits to blk_mq_alloc_disk
Thread-Index: AQHaX94/lQtUgdIVE0+UmuAK2yV8gbENtUIA
Date: Sat, 17 Feb 2024 00:44:45 +0000
Message-ID: <4c9adeec-e8d8-4fc6-bca0-6a21cf201e88@nvidia.com>
References: <20240215071055.2201424-1-hch@lst.de>
 <20240215071055.2201424-7-hch@lst.de>
In-Reply-To: <20240215071055.2201424-7-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|MW4PR12MB6732:EE_
x-ms-office365-filtering-correlation-id: 848cd9ab-00a0-4fb4-f928-08dc2f51a2dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Wx/ORxw9dviqvFfZ0wDIilrJ9KCT1pTqpS1KBs7CALev0dR130J7DaJhCLLc6moNV808FgStoU5ZQ++n3rDCQfXXvIiLU15vudgpWSHpgyn5akZ/sLtsCPpDabMODcCuctnUZl46oYooFnV9vXsRy4gAQeiv85b6VW1i2+XcdcR1OLcKuqIzVsVSQb21tF/tGcqb2W8kiFYpJkfz0gnY6XySJNkbfr7sjicPvbDzMZTX+Yq/bh8Wvt2lRYA/av75/nJ9JABthOfiAcd4OKnHNZDWXPbpn++BfvvVtGDOGTLBfMUYeW3dtJX1ycCMiPEP+XJZOkeMQVKOVcNyfkMx+cxklaJNDwKaPH7zXYbjzkMP8v5AGQh52rCbQbzV+chfyupok/VrAFwHp85NBkORXoQODWSN7BXGbTmheLkc1lvQqKWpaQKuKycQFt7fD/ea98Itmro75SQJR1BYGp/7gM8pNyI9gudr4M/2gWEWW2o2rdP+6C38G6TcMLSW+HDxWFJxWXfDvchXTNyOgPsEqzEWadaKq6LbxvytJZlGzuixxfob+Z6UqyD8YDzbTqsBRgQSBQBvbKs1sY9OjYInroK+Ojhm1ngCwjsW2H47okmurHc1wSvzjPXl64hI0RPd
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(2906002)(41300700001)(31686004)(36756003)(71200400001)(478600001)(7416002)(8936002)(110136005)(316002)(66446008)(5660300002)(66556008)(64756008)(66946007)(54906003)(8676002)(4326008)(76116006)(91956017)(66476007)(38070700009)(122000001)(6512007)(86362001)(6506007)(31696002)(6486002)(2616005)(558084003)(53546011)(83380400001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dVRzem1UcEx4bENGUlRyWXhKN2EvRlpkRTcwMnpLcTBidW9oTU1udWUrVnVu?=
 =?utf-8?B?UUgzZnVSSkhtUzhyRlE0RU1vZ0dHajBqOXhGeXNJSTYvZ0J3M3p1QzRCc3ZY?=
 =?utf-8?B?VlBWVXB3M0JicFg1WkVMS2lmaFFiTHJUcGsvbWgrVHdoelZraERLTndNcGFa?=
 =?utf-8?B?ci9teXlpbWhCRTI5MTdYVFpST1BXVmM3ckdHWE9EREphenNFdmY5RWxNUVJS?=
 =?utf-8?B?S2Ntd0ZaUHNIN0dvM1NDNXFYajJPSTk5NUEzdXhucUMwclRjUUc2RDBpcjJZ?=
 =?utf-8?B?S1RPdTExYmJjcGsyaXdhWUlDVmVWVVVrYnNiL3Iyd25hNnpHNDM2RCt1NkQ0?=
 =?utf-8?B?dVI0dWVXR2p5RHdoOC8yRHFYMVFjWDlBekR4RVZSb0dVWk5RNVY0YnRQZkZ1?=
 =?utf-8?B?NE5hd0RkWjZiaTg3VmtMTW9teXhGTG9pWHJvSnRCVnVDMzhlNjRnSERJL2hv?=
 =?utf-8?B?UlVHY0ZhWTZaV0dvWWd5MEFtS2tDQXVpYit6UjhTVGl3SUlxKzRkUnNwcDh4?=
 =?utf-8?B?M0lYTm54NGduRVBNWmNYb2hybm1sNkI0cXpOd1FQUEt6N0tZcUpPdzlaSzFu?=
 =?utf-8?B?T2tMYXRmMkxhU0ZkODViRlcrc1J6akpIN2kybHpYS04zSWtnOWdBSmQvUXMr?=
 =?utf-8?B?R3U2MGlsTFlhVEVFOHhrQXFPQzJISXl3bVJPdmRYcmZRRGJzcHRJNURKZDZF?=
 =?utf-8?B?WWhjbWRwRXVLUXJNTjhNSWQ5NDcybHVaVTFPSmdjQVk3UWNDVnJtY3ZSdXk5?=
 =?utf-8?B?YTZnUFFTaHJaWDB0QjdPVGc2djUyTHo0RHY2YUNlTUNyN2NNWmZTRkhEbUd6?=
 =?utf-8?B?NjhyY0RPRmtZVVhXYnJRdFF2dzhyUnRNKzlWcjlLZ1FZZjNqK25rZWtoaVFh?=
 =?utf-8?B?TlBmTUc5eUpwOHAyU29uWU5uU2pWZy92Z0FqQStZSEhkbHVXYkdFMlpnU0Vz?=
 =?utf-8?B?M0Yzcjl6WlBNaStRVDJ1b0s3MlhwZldsMGMvZ0lXNmNTa1F1Sm1YRDRYeWp1?=
 =?utf-8?B?eWprKzBoSlNJb215YkpFaGJwSklKdm1BREc1QnB0dHAya28zdGhpVEFTNDFu?=
 =?utf-8?B?ek5YYkFpczRsYnVHV1hVS1FuVjFIaXpERXpKcEdEYkh4S1NXQ0pIamQyRHdz?=
 =?utf-8?B?bFZRbGVoVklBSUExcHZUc1Q3MmQ1Q3hoZzNaUVJmQlhLdENVeUErZGIzTEVI?=
 =?utf-8?B?YmRtRFdhcXo0aVhzWnVhckErLzFTV3hLZzY3TmpKYVhzRVF6RmMycU1mK2N6?=
 =?utf-8?B?N2M4ZDY0bzRLYkpTVXh6L1lNZUxLRytPVFl0TkVRZnRjRTRYNGw3QVlUR0lr?=
 =?utf-8?B?WWt2Z28vYnMvMHV2NDdGdjgzV2lQS1FkWjB3Z2R0LzZjNTlpSUVmQkNPeEhm?=
 =?utf-8?B?dDNSSWVDS2tBM0JER280aEdkZTVsNWdIWWtXRmp0LzUyL3lrNGRSMFBjbGVh?=
 =?utf-8?B?elpTYjYxR3J6RVNET3FUN3NmZnRnQjZvdGc1R2VGZmFjK0ZiLzJMNjZkajA1?=
 =?utf-8?B?aE5zcUN1d1VnWFp2T0N2M211d2RyU04wZjRrNDFERGhabWc1MmpOZjcwQXg0?=
 =?utf-8?B?dk9tWmttM1N3azFhZjZkT1dHV1AzWXNZdkgya3RDTUVJOS95d0RVVXkvdGN2?=
 =?utf-8?B?TzFrazFNL1BFWXB0ZHIvTTNpdlN3eStiWjJiK1ROWHMvS2FSYk9abVdsTkpI?=
 =?utf-8?B?a3V5eC82eENJWVY4SWZxeVlUdFdEU05RK01BZ2VvaEU0Wm96Q1hkWE1sT0xz?=
 =?utf-8?B?dHQ0cXQ4M1hGMHp2Y0xGWFNVYkdZTkdKdDdscFh1WXFjaFE5WkdDZ1JPeHVs?=
 =?utf-8?B?bTVxemh5MjhPTW53RWpzRHF2U2ZkZUdJZTZ1ZWRPMVA4WWZ6L0liNDRzQkd0?=
 =?utf-8?B?bVpqdW56TEN6NmJSNEw5Q1Z0bWJaQWU4c1FOUHBScEZKMXIwci83enVxTWpj?=
 =?utf-8?B?azdTNVhrOUVkWVRIK0NpWWorZi8xYnhFZ0FKS1g4aDhGd0ZZS0RBUjV6OUtX?=
 =?utf-8?B?TXo1WEN1UDNkYXJHVXFXczAybWxWYXozbGtwMENCV2xtQk9qaEx6UmQ1SE1W?=
 =?utf-8?B?ZlB6WUFBV0I3Q28zcmhZUWVZNlE1elNCTFQ0NHRGS3NaTjhPU1dERW1ML2tl?=
 =?utf-8?B?KzZUaytpWkg0b2lzOWJBYVNqY2xkNzNOUGVkOGdPdkRqL2g0WVBhV2xxaVI3?=
 =?utf-8?Q?CWgRFfy1PPkaaCp6iOz1QfUoJ5wy+MliMuc6fduUqBpw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC05A43D45A22C43A1E4F9981DBC7FCC@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 848cd9ab-00a0-4fb4-f928-08dc2f51a2dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2024 00:44:45.0884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gOT6k6rAV6qeY5V+bDKfluQQL8u7mPOc9weNZ1HsyDupgNXjN6wNcOs6XasDKXu2KFnl8wztkQwbp9z470y2ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6732

T24gMi8xNC8yNCAyMzoxMCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFBhc3MgdGhlIHF1
ZXVlIGxpbWl0cyBkaXJlY3RseSB0byBibGtfYWxsb2NfZGlzayBpbnN0ZWFkIG9mIHNldHRpbmcg
dGhlbQ0KPiBvbmUgYXQgYSB0aW1lLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVs
bHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQo+DQoNCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQt
Ynk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==


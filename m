Return-Path: <linux-bcache+bounces-274-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D29858BF9
	for <lists+linux-bcache@lfdr.de>; Sat, 17 Feb 2024 01:42:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B5B41C21DDA
	for <lists+linux-bcache@lfdr.de>; Sat, 17 Feb 2024 00:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D9D5149E08;
	Sat, 17 Feb 2024 00:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="f08ShUVH"
X-Original-To: linux-bcache@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433EAEC4;
	Sat, 17 Feb 2024 00:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708130574; cv=fail; b=pssLsBBrPsgmUsNbrgMVCccZT9Bq44q9X2i6/HJEmoQJCVAl53PX9m/Tsrgo/be8WJdYAXb1AA1j0R8sXhHYVgO+X5Y4hMDIyNB8nPh3YMjaUeLrEz/kW4n6SjmBV8pCG8OmuLaoTc6ixBlkDXxPlmpxpgPmrKGfrVCdkKYCQIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708130574; c=relaxed/simple;
	bh=WrTcxKwqLjU+lEim/9DWgWQgXtJWHXD75Rdo3+QkT4E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fgbdVxG3D+oNzbNDYhlSA9ZstftfWWSWj1Nbi/4I61Tup4VAf3xlFGZI6Q37tnfMeuuLQHiJcV92AG5nRxs2tbS7yDR81t20QphDPvKR5rScuGa+hvyaBwzgoHDFPNvJFpjLLr5O3NYbHZK7mvsHcRMVQyAjRLoqjTQLunD/Txw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=f08ShUVH; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=io1+juykPMNa7BaVIqTFefl01u2zhD1I4KKYygxBOjTKtyq/Xq8+wEkT+slsfr3Yn/D11Dle/+oU42Cs8FGyG3k06kaJJSou80czRR6PnYX4fnGUBLOJYkfbb59JjBA1NhddMyDYgi8Y7fhqOo7fNPOCr2SlAkIzMnoSBpDSA5UE3R1E+NKqCEioF/JVvU4+ymYCD/e86MKbYIYv8Q9C9//BgqzwvuudEhI0TXmDoWhdQEeu8z7hiCxahPlF0zHAnlkI5rmjPGy1elC20yEzLdAyGsmjXnhQyKdrwIW+hXDVO9oMhyNxhJZN5LGePq971erpYAybyEgDQonDLQ0qmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WrTcxKwqLjU+lEim/9DWgWQgXtJWHXD75Rdo3+QkT4E=;
 b=Xi48fEq/uIEAyumJR2vJ2oiuRHlhCBaOJfesLNKv7xspm4yFKty2vMwUwrDzkmq/pFJvzTqQwy6U7Vu8gAgu5rP7z0cWb/IqKL8d0344mdAKPXd2B7PPZ1PsjVFpUOJD53fVzIwtRPNdW1ZuJNON68tKfPB6s8va2fJ/TULYNjqC+qbIR3e5L37XEtsYwKMdCYybHJgcMhHpxivap+7kRlhrVTqFWOVgrPgZxVnyyoFYyQqSMqnu1291MDrzZ1PCau09gqM5o+ZBrkl7Tm7izV3/vS1FPBdm6HFzwMg3ZiLAleHbRkcIJqRO/PPcV67IVjkAi+wboJw/W1leShnibA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WrTcxKwqLjU+lEim/9DWgWQgXtJWHXD75Rdo3+QkT4E=;
 b=f08ShUVHUS2VMbd4rxujILsOiLlP29dtxvpKR48cQab4/XUHrtw0Xf0BVCVncQxWnDdeYS0LUDqvtLn1tv7MsD+doFaGt2c3BSV8pfGZfjIzbUfeg5nrPhGdrWpKZRaw8LAEdRkGg2sqqvkHknWSuf+1iIme572suI2/MdOiRO3BFnkeqmVVcrSzwuzWmt05G3O4JyUgkJt+wjKgYlDdl574QefTveXtkfCbMK6jVUqeGl1Ix9lwR4seZP6Svnawx7fWBL6ReieAM7nUtZXrFKuNf7cJyeK83UT3ghLRV1kimvUA8Q24E1xBe6fagN0RTVJLaLsjaQkZUap2OKeSqQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by MW4PR12MB6732.namprd12.prod.outlook.com (2603:10b6:303:1ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.14; Sat, 17 Feb
 2024 00:42:48 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::ffce:bbde:c1ca:39ed]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::ffce:bbde:c1ca:39ed%4]) with mapi id 15.20.7316.012; Sat, 17 Feb 2024
 00:42:48 +0000
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
Subject: Re: [PATCH 3/9] brd: pass queue_limits to blk_mq_alloc_disk
Thread-Topic: [PATCH 3/9] brd: pass queue_limits to blk_mq_alloc_disk
Thread-Index: AQHaX943QkSnpIoTF0+bdo9KyhkirbENtLeA
Date: Sat, 17 Feb 2024 00:42:47 +0000
Message-ID: <e003dffc-3b3a-43dd-985f-a6147889bd15@nvidia.com>
References: <20240215071055.2201424-1-hch@lst.de>
 <20240215071055.2201424-4-hch@lst.de>
In-Reply-To: <20240215071055.2201424-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|MW4PR12MB6732:EE_
x-ms-office365-filtering-correlation-id: 0616f4bb-94cf-4b61-9977-08dc2f515d1a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Mui6zhGPf2UGysNENX7yczqdRsEaZZUxC30pcDyslsJyEGW1wlJHzksrcxa+Mm9qRJlGzZMXjKDU2qmk5MdkyedJkDCsfEHpN+vuob0hnHHJzaC9IJ3awm9+Nxzjb0DU8k8cVhPg0blSgALAOJntQ70WhdwjgBuBTfBR08NzfgWjc3eKikcfLwV9sDayNzihrtFJfjex1jRJPMvVbhEOOec3MIcSquDJkPBzrQ/WTEY6wZqMVycnySktd2IZoqdns+2N/Fy39kzqED9qS7pI75M012WOhF29cnfMfCQMtx4mmEC/92qj5a1nmQLdyiZKz3IiBMyzNKCqllzswTK9noW5iXwZFm+m/EZfV8/FYzgKjfCtOnf0hLP4WJKNXQmo6xJwydnrHfyhyBSJKa4ULTiVMwzUCL9zHPyFdNBe3Cuuy2MfiIjzt2GmTjXwfEfAwOEAWVqrOOZsJHk0WkpqqKEOc3n+i0twOHBZeytiSLD1cza3iXWwCyFwkwLdecaIVrnDwZAL+bJQtam55KpGLGsZ8f06xzw6W1GhNQmxEVmyy+jtLnskEFq1flJYy9tWQECMUB1KKT1aS0D2vg11PUitYTlbGZp/FhjJ38wR1nh+zmCKjW28gOM7bBWRjfzS
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(136003)(376002)(396003)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(478600001)(71200400001)(36756003)(6486002)(31696002)(2616005)(558084003)(122000001)(6512007)(86362001)(38070700009)(6506007)(83380400001)(38100700002)(53546011)(8936002)(7416002)(110136005)(316002)(8676002)(4326008)(54906003)(66946007)(66476007)(76116006)(91956017)(64756008)(66556008)(5660300002)(66446008)(2906002)(31686004)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZllNZk5TaDAzU2kwa0JtUGswbUR2NzZoQnRjamNzZ2VNMS9obzF0cU9nN3Jr?=
 =?utf-8?B?RXlqbjdwT0drZjZXYWQwNmxxVFh6QUtzdjJseTRuWldLZlg4bkpmMTFybFli?=
 =?utf-8?B?TFR5MGFSZXZEK2pQeUxrSTE0aFIrTkxGWDU3TjkzWDVDK3BsTjk5aWJpQ0Ex?=
 =?utf-8?B?MWd4TWFrSUVNWXdtWmZFRzVTRG15b0hvME16djRTZkQ2Q2h6ejlFRHR6TTZa?=
 =?utf-8?B?RXNjQjNWVFozNG1lelptL0R3b0ZVcFJYTWdJNllkZ3Z5cEV3cnUrQktFN3I4?=
 =?utf-8?B?UUtqWXhJc0ZEUS9GQkRiTE9IQUZjdkpTUHJzNTZNNnJGT0pqU1NGUkwwYzdR?=
 =?utf-8?B?RDE3ZTNYLzcxRjRibklsemFXQlZZN3hxdUxLaEFpYUg1d3NSV3puREYzVmxL?=
 =?utf-8?B?REVmWmxCd3htQ1BuVHVmOUV0a085UUZGMTVHVnVEUTZNZzJicjBWZjI5Q1dq?=
 =?utf-8?B?bVlEQ3RqWWxkYUdUd1pHLy9pSkQ4Yms5WmptaFkwaWFicGxBQmtkRXpJeXZj?=
 =?utf-8?B?d3dsL3FMMWUxNzRmVUZvSW02bTE1VTAvTTltUEJnRmplVlJremd1NVRNNU1F?=
 =?utf-8?B?K0pqaFpaTm11UDFjcWZwVGhXZnl0OFZxRTZucnpBakFFbEZxU2Qyc25MbUFh?=
 =?utf-8?B?ZWNGSmFtWmI2M0RhaHczVWxhSkVwNHpTbTZXbzY4dS9SSVJFQUNxemRvQllN?=
 =?utf-8?B?dGRXdXh0WWtwL1JqR0wxdnRNN0VuenRVRjNQK2pYcXhUaGlQcnhxUnJrY0ky?=
 =?utf-8?B?V1NBYVBWYlZMZENHYXRmSlpXdXEzdTBvaGVQMnpwYlJqMTBWRHR1Tyt5SThl?=
 =?utf-8?B?SjlTZ2h4dWxQRVBOY0ZCQm1CZTBGVjBBdzNBRXNRMlZaU1l3bFBxOFVLUGdH?=
 =?utf-8?B?bEZFTFNIMldwVk9rdUF3RlgyNmo1YTZFcUp1Z3BIZnF1VmE0ZTQwdHBsYlpB?=
 =?utf-8?B?K1FOSjVXeThOcVBYZUtpeXZuZGM2UXZUQ1VuUzVJOGtlbWEyVFYvMlk3Y0xE?=
 =?utf-8?B?TGR6VlBUaW9wZ0xQb2VWWGlKaG9jUndmajMySUg0NmxWS0VROXMyYk1tQUJO?=
 =?utf-8?B?VENIS1JQbHFFVWxlSXFZZDQrRFNjdXdhTklnUm9PQ2kyZEdCdXFtOWdlOSt6?=
 =?utf-8?B?VXQ3VHBOMXU5RjNOeVFadVBUL3BMcy82QVRKVGZwZG9maFlQOWE0aGpsTHFa?=
 =?utf-8?B?SjFTbitXYUorM3FySklSZ0ZzZ1VXams3RTZ2VVQza25UakpMZlpKYzVieDdD?=
 =?utf-8?B?cmVBSUJNLzVIVCtySHdxZGc5VTlkeGZkRTR2YWZzRlVIZVNWaGk4YWRkdHdm?=
 =?utf-8?B?Z1haQW5ZZThUWjNicVlDNkd6VkdtUDZONkVxVEJpZXZjYXIxbFY1QXFIckho?=
 =?utf-8?B?bk9Kc0Vwank5NEZYODV0QWhVSW1qMzNQcVdpcHMrQ3E0aURtL1VvNWk4L09y?=
 =?utf-8?B?K0dMZ2REcnl4QU0ydU95MDBiVjRxanQzOGpvVUlnbWRWZWV2SmhRT3htVWFR?=
 =?utf-8?B?NHF3dHpBTzRKdDhBRDRrSUtRQ1ZGWDBJNlNxNHBKOThDTGJSVXkzblUvbzU3?=
 =?utf-8?B?eEpYdjZWQXZqYU1HbkNuU1ljMUQyTzNjNzNxcnZ2RjBiUEgxUWZudFdXOVR3?=
 =?utf-8?B?d00xODQrVWN4VkRrcmI1VmhKWWVhT3Q5akF5Y1c1Y2VLaC8zQlZmTG1hdVY3?=
 =?utf-8?B?QmZ6QnAzeEZIZi9pS013bGRYUUljVnlwazJVNWNlZzhNbktkUkxuV3kvZnFO?=
 =?utf-8?B?Tmx5WWR3V0xLUlJKVGRRUnd2WmxyRjVEajFyVHAvY2hmUEh5YVNMQ2RRWTBR?=
 =?utf-8?B?UVVmVUlvdXpaUGU2RDVtczVjU1dpT1FSZkx3RzQ2MUNzOFhyKzB3djJTMVdu?=
 =?utf-8?B?SlJPbUxIYzVIcTdBQzhOTDFkNHBCcEJEQlJjdEJGLzdYNkVPZDhJeHNXN1Z0?=
 =?utf-8?B?NUprYUk2YlRNcEZhVEtIM0Yxa0RjdjFjR0I4NlMvMy9NRUQ3VVFpWENtb25X?=
 =?utf-8?B?VVlubEpjQVAwNiszTHV3eUh4aytyUnFnYWJMUFhDcmhoamR3dnVQQzRxczR5?=
 =?utf-8?B?OGhLNUJhU1c2b1ZYTWlHeHNEdDl1bUliVjhLMWxIRkN1SGoyRUNITHVwZENJ?=
 =?utf-8?B?bjZMK3gzY0JtbktKbGRuVWhZb1U0UU1WeStXQWZySG9LRzY1dzJCc3A4RWlH?=
 =?utf-8?Q?Lg4e9zHgrjXIn5NFGgMU2efkQWrZWQv44u4F+/nB6S6R?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8ED39D8057117E4CA2E2AC76E2843801@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0616f4bb-94cf-4b61-9977-08dc2f515d1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2024 00:42:48.0043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l6l98E0rPj3wiAHMrK322602igj0z4cm1ztt4HsukD9j9d1TIqXK+SAtLmQ/HlcUo+hWTrWlrycvNse9qbZb8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6732

T24gMi8xNC8yNCAyMzoxMCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFBhc3MgdGhlIHF1
ZXVlIGxpbWl0cyBkaXJlY3RseSB0byBibGtfYWxsb2NfZGlzayBpbnN0ZWFkIG9mIHNldHRpbmcg
dGhlbQ0KPiBvbmUgYXQgYSB0aW1lLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVs
bHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQo+ICAgDQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2Vk
LWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=


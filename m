Return-Path: <linux-bcache+bounces-275-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8332C858BFD
	for <lists+linux-bcache@lfdr.de>; Sat, 17 Feb 2024 01:43:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A74A61C221B2
	for <lists+linux-bcache@lfdr.de>; Sat, 17 Feb 2024 00:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9E0B149E19;
	Sat, 17 Feb 2024 00:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Wh0ID3WQ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B71C149E03;
	Sat, 17 Feb 2024 00:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708130600; cv=fail; b=VBP6TdCAkAfn+L8c2aTpOlCRKS156jSYQW3xT4wUDKJdzoRSpyIHYcKz+N9YU3TpspKMH4V8nx3kjGqLS4Ue213PbZCPPQhxavtX3Of7871Iu/1R3TTzxlZkyMYvv/pUPHDqChuqxJF9weOtPsuk/+ErhvOFvy340q+SmzBM+XU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708130600; c=relaxed/simple;
	bh=WrTcxKwqLjU+lEim/9DWgWQgXtJWHXD75Rdo3+QkT4E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FNaHKHv0BDYguh2zcsDyEnjG4nKxztSZYi641CwHuGnp6SSi6M+g7mCe6DhhjaM5iicJVr+SmSVur6ZqtojwiI/P6c9a1P0j5ulZW/9ToUJVR0WSAqsOwdDJXAseo0TYAWk9MKSn3XGGXL7BsY3AWpO1fyiqqNTda3fmT97LMh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Wh0ID3WQ; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTokBQsmlSebXSdZVfWEJ/DUrR5n1z1sCDD/UB2JJyo0y1FPrSCADP85TE1+vfXdtqVXjQ6tL93GftfDXCZfXV2ok+aZyc9OJ3Imi3qt4BjwHytEB6WjhNdhGdYBG2hZeB4DutubkhSnwE5iYj+GtCDRvGMBPaFSilcUkvkue2irFdGnH2iLlPDNwF7YPqdGSfGgZd1xofS+aMQ8JftFnsFoFmVPoxUIYSFSpruySy7/hSnfcYWU3PD2K6ihcCV+n4Q6QqKqhW9/lykM1viUZ7XirHDKGgQS2FsaMDK8+vf+c8VZxSp3GYm51hZ298Ec46SVUuhIk+5q5Z2xEOn9lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WrTcxKwqLjU+lEim/9DWgWQgXtJWHXD75Rdo3+QkT4E=;
 b=QKMTWaM3qpdVDkDjQmystgj8d+PiPL2ZTED0jXN9KkbLWaSXkobQxfLKOW/glMuvLH7sPXJtvLZXg7b0seJOszHAMkw6h2kzCIGzzEPDrjVhLIaEfdYQYiyD36FwDx6Yx5yEa8ErBH6o6lZDbfsFwtIfB59lDCbCijmBlcr3j0sk5xMTRM69MoyDOHK2n5Awlseehz5teruuzYdUL+5IUzytS4wO5+zOQdXVZJKqcSq1GPQvv2dXZpefdkP3kRvACGQhseRghaSsXCzuU7crCOJcva6rgk0nqv3kM+H8q37jp9wd0mux0RWfqSxuT9g5Q5V9E/eE8FcNsiXwOKVXIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WrTcxKwqLjU+lEim/9DWgWQgXtJWHXD75Rdo3+QkT4E=;
 b=Wh0ID3WQ4e7TDZ999QTQvC4vCVhhgTMym4kOg81ElBclAV5i5w4ESwc8hfsEK0vqjsVRD6jPDEpeMhGNZHI8tdQBOI7N9HpbeV7iGxtUV4ofZ0q7UJ3bZ6DaPWiThVTl4EKYmtjOeKoOlBI/lys+jhU6R6qq07wWiTblLz3JWYjI7rQ9F+dBQzx30XJQ4HyiX7oHdPSVzwuoIprdLDLc9kjRRqfq8ofXl5AIhau+gaS4AowGmiyxHN/zyM6PstNFasMenZLveljxbEzuh+QLqG4mb7Kwp89Ani/zX0XhR7XJqTIiNH6Lq/tRYjlv9+M9qO3nXtjK/eYT6VJgkWxHdw==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by MW4PR12MB6732.namprd12.prod.outlook.com (2603:10b6:303:1ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.14; Sat, 17 Feb
 2024 00:43:16 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::ffce:bbde:c1ca:39ed]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::ffce:bbde:c1ca:39ed%4]) with mapi id 15.20.7316.012; Sat, 17 Feb 2024
 00:43:16 +0000
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
Subject: Re: [PATCH 4/9] n64cart: pass queue_limits to blk_mq_alloc_disk
Thread-Topic: [PATCH 4/9] n64cart: pass queue_limits to blk_mq_alloc_disk
Thread-Index: AQHaX944npCDwK1yZU+Nju5KpSYK/7ENtNiA
Date: Sat, 17 Feb 2024 00:43:16 +0000
Message-ID: <086ea3c1-d18d-46e6-8268-b8574bcb7661@nvidia.com>
References: <20240215071055.2201424-1-hch@lst.de>
 <20240215071055.2201424-5-hch@lst.de>
In-Reply-To: <20240215071055.2201424-5-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|MW4PR12MB6732:EE_
x-ms-office365-filtering-correlation-id: 69391851-a506-4ddd-cb2a-08dc2f516de0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 5Od10Fopb2lYhiV+Qf84FqQAx0h0WmRShDdO6Dn2DpDWtPrReE0McXscIRrzc7L0L5XsaZ0qFZTOXS6IawHL7gikJB+JssroPHT/ZtMUBMpByWqs1RF+QTes7FcusfuebOqDrejow7kQl1N7QfpIv/pe8beph/sIapzHkTmRAMgvGQvmYYsLjhGYW2G3FpTQatEdn/DJUHE0PITp5XzSEqA4TGkLvwVx7aDsBlRLnoFAR8uteSrc9E0fUosTpQe21y0pKLvjBQZdnV1pJxMHGL2DV7We3htBeE5/AhI3zrzou0lIefzvblog9FjqcTo8Jrn9RKdvznm/71FMnp7ulRnNrgXRV8esWZ7Bq5Efjo7J8BHBBHe/irnUC+oN1SKUVshYc4KxBSt9p/3cBZRLUoo61OH3F39iLaAY+mkssOw8xNpLsCnWirgBtR5ycFOYUUD3ZZSaI//T5hfAPo2QiIZfeZi+Km8Jl3rD4FIPNPs6IYcaiuSptJrVPlRKZUsevokmydIWktbaXm9xbhOtlZpwkGEJvHT80hc7/OR3UGYULer1cqyNKgWV5gYyNLfmPdTS95isLCF1mb3OR32w76LKTl0HON5I5cmkaWAtNEeLnmERiYe95/8UjT4ZiLpu
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(136003)(376002)(396003)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(478600001)(71200400001)(36756003)(6486002)(31696002)(2616005)(558084003)(122000001)(6512007)(86362001)(38070700009)(6506007)(83380400001)(38100700002)(53546011)(8936002)(7416002)(110136005)(316002)(8676002)(4326008)(54906003)(66946007)(66476007)(76116006)(91956017)(64756008)(66556008)(5660300002)(66446008)(2906002)(31686004)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R0tpckx6MGZ0YmJqVUEvcHo0T25nOEo4a0VPOWE5RU44aHltM0ZLUW5DS1lu?=
 =?utf-8?B?VDRGaEVpc01pTStrOWd3Zjk3T0FaeWs5RmswdjNWUUZXdlE2VjhEV1h4WFBj?=
 =?utf-8?B?SjZyYWU4NEFyUUpWUklLSTJ3TGlXbnZLakVCRERxdXhBaWFoY0ZadmcxdUpD?=
 =?utf-8?B?bHNjSHBaQndDWjJ5ZG5Bdmp3OWdnVFp1WFUzOWhUbHUxSzVyTjRRZmtxTGE3?=
 =?utf-8?B?TlN2Ris0aXNpMWlIWnBJMkZ0dWFGaDhweTJKaU5mNUhCb2hWUkhjVGlBQ0tz?=
 =?utf-8?B?eGRFR2hmU1VlTS9PdzFlcVhPZjRhenUzc0FZL3puNi9KbllBUmpYYit4UFRF?=
 =?utf-8?B?N1FYVUdBTjZSRkZxakpIT1JpYXhqL3Q4T1EwaGJFcHlpT3RBTU1EeGFobHp2?=
 =?utf-8?B?K1RJMTY4NG4rMG14L1ZjeWErZmVmeURRRDIwVjJ4RVR3K1czVWMwcVZPa0l6?=
 =?utf-8?B?SExKYnEyU0IxNW9qcE5zMlRhQ1h1Z3lqM0F0aGRWc1hxOFlINzc1NTJzeDBP?=
 =?utf-8?B?OFQxalF2VjNQQ1JIZnRyNFZlekZGdU5NUW1TbG9UVzVEdUZqMTVFdlNQZVNq?=
 =?utf-8?B?d0tyNWlLSUFHOFk2OXRVVkZKY1ZUelhBWUlsWjBPdkd3em1rbXNrZnhsVTRV?=
 =?utf-8?B?bHBMVHBJemczOC9rOVJCRzF1cWs3SDJucXBsVjV1akpYVFNySmRkWDZEZ1di?=
 =?utf-8?B?emdrS0RMS2ZiRWxwOGtRMjhnQ0oybmdBWUNyYUNNT1Y5SmRQbXVWSjVNUWYv?=
 =?utf-8?B?K2tVMW95RElPckRtRndaaFVBak56R2JyZXU3NCtBWnJaVGFRUHRubDdEb1Fx?=
 =?utf-8?B?VUI3dVVVdVFxNzlkS1JUdU5EVGNDSDBlMWxQZjNBWThhTWFPcFJKUjcrZWpW?=
 =?utf-8?B?RWhSVkk3SmR3MU41czQwUXd3cmtkVStvdWYxK1R2NFBEVFlJZFRMZnJ6bi9K?=
 =?utf-8?B?YTNjcVZKdHU0Yjc3bXlvMXdUOWg3eVVXeHVENjVhOW9Zdm5uVWNWWkZvNExt?=
 =?utf-8?B?RDRYQ2xNQTNYQmplbHFoNmIzUWRwb0c1Yi96WmZaZk8xOUNUemJHWTBCUHBw?=
 =?utf-8?B?MmZtS3hoSWpVYm1vTVZ0bmpFaXMxc25aWHZlUkhNRFVSK2poMDErRnlxTmFF?=
 =?utf-8?B?NXdDQmpXQTdYRTV1UG9Ca1MyZ0YwVzlmRDVKUTFiWjRIVE44aEtzV1ZJbGNt?=
 =?utf-8?B?TGl2RzFuVk1sYXdWWkF5aHZHOEl1ekYyZW5zdUloNldxUC96bzV6N1N2a2Mw?=
 =?utf-8?B?Qjhyc1VtK2JCWFBuZUtIR3NDTTRwQmVhampSZlBqcjVMZDNZdEZ0R2ZmSVVs?=
 =?utf-8?B?ZHFoeXpQQ1BrelRpVU0vTDRXcFIvN3VXV0dtZUZlMXBrZUJiWHJBamtLRkNl?=
 =?utf-8?B?T01aYVdHcjFkaXZHUjdkYy8xck9TRG42NjZFSWZORy9DcWZRTmJlR0RuajVy?=
 =?utf-8?B?RTNGS1lwWk53cGcrY0xGUFA5UHB6bGJJVHRwTmxnWVp1VytzV3I0SmJnTDJC?=
 =?utf-8?B?TkZnRlRFZVFISEUxNklXRkVBL1l0WnNPRDdsZ24xR1ZSZUY3WFRsTUtXcjVt?=
 =?utf-8?B?S3g3dVA4RTJUejI3dWtMcU5vTkdRL2kyOVBPd3F3ckZhdmNjU3E4SnZCTFIy?=
 =?utf-8?B?VDMrZXpKTVFIMzBaeHBTN3FoMjRpNEN1a2VnZGRMeis5bTFNTDl6UklLaHZT?=
 =?utf-8?B?QlUzZ3FLNjg2ZmJiVHo0U2hYRHdRaHJPNUVuZHcwZjRYdUhGZjM4TmYvTXRS?=
 =?utf-8?B?OU9EbUZBb3Y0MEREWWhjQ1FQcTkrMGVEOWQyMm0yajhyRC91YUo5SEJDMkNN?=
 =?utf-8?B?TmJQenM0THl6dTBhSDA5UC9NNGNCTWRVUFVCOFJDV1MxRmN3MGw1Z2E4OFJV?=
 =?utf-8?B?TUZzTVRPdDlsS0xXY084ZDNTRWFEQ3NwRytLRGZuY21vdmh0elhTczZ3YURX?=
 =?utf-8?B?Tm9kZStJVitLcFhMYnJQSklmUDZxdFNVcG1idWI0UXYzWmd3MzRyY0UwSncr?=
 =?utf-8?B?L3J6U05Rc2VZWnJsMnJrK2p4d1FuTjliUVZpbDZWY2VSSzFuSWE5dzByQTEw?=
 =?utf-8?B?YUlEQW0velVsKzYxcWxLOGRPL2JrS2RFTUErNWVTLy9mbkwrYmRWZEhOY0VE?=
 =?utf-8?B?N05oTHZnd1Z5RkFISmFING4rVTRIci95bUtGNEw0VWgva3RNeVZ4RWdQVE44?=
 =?utf-8?Q?WG3AqDDzUfV+5nzm7gGy1nxDreja4VBZqqmU0tbe9SDS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B41228450E4AB479D3FB18D6B087A24@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 69391851-a506-4ddd-cb2a-08dc2f516de0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2024 00:43:16.1826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3/5LE5O4i7+v+9Pe6gFQeqjSm+fVzd79+RcspqA87vHvsDzBJrBdux2R63HfDJsccstoBgFC731ihLY50Tjwzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6732

T24gMi8xNC8yNCAyMzoxMCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFBhc3MgdGhlIHF1
ZXVlIGxpbWl0cyBkaXJlY3RseSB0byBibGtfYWxsb2NfZGlzayBpbnN0ZWFkIG9mIHNldHRpbmcg
dGhlbQ0KPiBvbmUgYXQgYSB0aW1lLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVs
bHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQo+ICAgDQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2Vk
LWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=


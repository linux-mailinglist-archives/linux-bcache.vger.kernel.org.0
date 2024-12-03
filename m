Return-Path: <linux-bcache+bounces-817-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DAA759E111C
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Dec 2024 03:10:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 444A0B22986
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Dec 2024 02:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB55D13AA3E;
	Tue,  3 Dec 2024 02:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AGFQ6q9X"
X-Original-To: linux-bcache@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A1E1304BA;
	Tue,  3 Dec 2024 02:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733191837; cv=fail; b=bh3r/yFnafcTmC7oNL5b1RZRn3O6fH1DiPKk/4rnl0F+lf6cjlbZ32m9di0VcRz0Vd0J+376ukfJte8eF/DBRDyVn9rHFFL5n8zcTFtvtyCO3Z+IQAY9dM8EOf9y3Rn0urNIYx6kwX5GNoDZZpfbDYw7utzqeV7nIH38kl2ztZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733191837; c=relaxed/simple;
	bh=4c3pfNU8Og954UBow9Otpx7CmGo0CiwTLaNpwuLNpdU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ouEKXUm3NqUbx2eSsD1+bsO6PcTdyOWv/Z0gL3WeT7E/1xQefHywFk6aBx7EBz1WxJtglph19xzqjjwkjvGVxrZ8XlQ9e/x2TxPkO4StJ1NUgFG04WgKmBzEDLRyCgoOgGFX9kl803bDEi093Wf14JB1LkwFLTyr1eHWdvRXIWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AGFQ6q9X; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QXkY9bZo9ma6mxSiWLImHcVMfLwuh2fiD/qLw2tqcxn5MvhwHcCjYlKH82d9Fmqn8tgOywAxgMyHc3RNDRUAVg89FVxRqKh5Bp6Y/NIFBNhT7Kn0UOEHI3qk9RmEdetYLsz7UaXJO47/o8KIUyT31sI1hlwiVmFJ20UCNOYIOMw9CzhSRXMokfqE3XNYUx/xccUho9xggoaY6GvcVevxngNHxzX3dNGLG7deDG0aixhFHZms2PGmXGLjY1LFHxtzz9vM5wV/rz2XLX9Jh9PxZurZ/5msK7BMw5X7CeXRYkPQLjYPLiYM2TdHna5PV1E/ETq9h75RjOKwF/VAtCcp2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4c3pfNU8Og954UBow9Otpx7CmGo0CiwTLaNpwuLNpdU=;
 b=N9AlKZnkfqgz6qAeMB9VldUsG6HJYOASa73w2A3UdcxBFHaL9ImqarC36zm5ZAS5J7GOYMiSCXgziKnxAD7vGHQf1K0fDuzruP+1OMJxe+umE8sA3f0QRHZYlxgCkzhOJIK/j1hbu1VOc/2Va387qGo/oPf1hMPWxwAtFrX/AG4i7FnnfaD6fz4gt4y/7o88V4PCEOU8k8lb944yRDWKH3HxvtqkylT0ocI40mWkatydAKMxNDSj346edjvNFn4LH9DEQK7PzkQMoFmttW/sHJHe+etzJxkMemzIhPDuqFT1AFWuSx7XL+EhBvAv8dcVY3YMqA0T1eCT0iCgFizWdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4c3pfNU8Og954UBow9Otpx7CmGo0CiwTLaNpwuLNpdU=;
 b=AGFQ6q9X2jOUSMYF3qa5vxJUTCK156mmcnzZma8FbqTWbPFzCWGxY1B6wt7il5H1SB7jB8LgjD3hP1cu7QT0hloEvzVhNd4gpqXQIZsTcOZZv9ST0ASKSFRXaVjq8+xvh/QK+OBXNmpPWK54yfsywyU7DNC01MO5vKm70ik7UQcoCVY58NvfenB5UXmXlJukcITIBUDPn1ZwHpomHtyYOQ0Zq+ouJyeY0Aj9Sj7/EIFnBlVoDhATVODth13INYc+4njrWuu0wFULvANYyjIN7cV9yKPz9irYNGWC5D0hgSoRxr/ahSaUCOcSd2gs3uzjEvwrQKhcyfVBl6uAX+kdnA==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by MW4PR12MB8612.namprd12.prod.outlook.com (2603:10b6:303:1ec::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 02:10:31 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 02:10:31 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: John Garry <john.g.garry@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
CC: "haris.iqbal@ionos.com" <haris.iqbal@ionos.com>, "jinpu.wang@ionos.com"
	<jinpu.wang@ionos.com>, "colyli@suse.de" <colyli@suse.de>,
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>, "agk@redhat.com"
	<agk@redhat.com>, "snitzer@kernel.org" <snitzer@kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-bcache@vger.kernel.org"
	<linux-bcache@vger.kernel.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, "linux-bcachefs@vger.kernel.org"
	<linux-bcachefs@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 0/2] block: Delete bio_set_prio() and bio_prio()
Thread-Topic: [PATCH 0/2] block: Delete bio_set_prio() and bio_prio()
Thread-Index: AQHbRK3BWCOuQtxdHECPqDuSufibnrLTx7OA
Date: Tue, 3 Dec 2024 02:10:31 +0000
Message-ID: <14da2382-5523-4207-90e0-ddef7c69e496@nvidia.com>
References: <20241202111957.2311683-1-john.g.garry@oracle.com>
In-Reply-To: <20241202111957.2311683-1-john.g.garry@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|MW4PR12MB8612:EE_
x-ms-office365-filtering-correlation-id: 295fa57a-8098-42ca-8a69-08dd133faa3d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YTJqMTVaZ0ZlaDJkdlFDM0ptdzNWcG41VlAvY3dtaEZwQUZXV3BEOVhWbGh1?=
 =?utf-8?B?cDB6a2xDcVJ2YTdjNmpSam05eEY5c0cwam5xKzQ0R2xCTXJJT3N2bDFMZkFu?=
 =?utf-8?B?RkU1ak13QVZCRXoyY2JrMzVQSnQvbmJHM09ESkNDR0JUVnZ0MlA4Ny9EeGVl?=
 =?utf-8?B?UWQyMVF4c3lYM0wvN0RRcm1ESDJWTUdqZkZ5ajdRU3FVMnI1d2YwcG1vZW5H?=
 =?utf-8?B?Y1JpYkI1WXNwelFBSVhxeXFRUWhqVGF3V2lnUmY4eUtsUnVIeEQ3a1czN1Mw?=
 =?utf-8?B?bGdlSDZnQ3NaUWZnYzVQakJ1Q0xlODlrTlpUWHpNMEpzUnVHRkFBUUVkVFNU?=
 =?utf-8?B?clA4NW80TGZBbzZmQjdhT0w0a3FlM2M4WElLeWpEb01WbXB6N2IxVXVVMXRR?=
 =?utf-8?B?WndJVHRKYnBqMWZ4OUxIUFR5NENYcDJqbklaeEZVZHVnd0U2U1AwYWZmV09P?=
 =?utf-8?B?YWt4dG5DeGVnb2lkL3ZleHd1M1k1cmgzSFl2UkxaYTlLM3FrWmF3RFp5S05P?=
 =?utf-8?B?Y3hneGhZM21Ubjdhbk1wVkNBLzE2VHdZR1VXM2NkWG05MVNjZXF5NGhnUUxl?=
 =?utf-8?B?VVBLT1RKenNDb1crV0x4ajNzcHdwMlVGazZmRDRDcWN1bUFlWFVXVGtDM3NS?=
 =?utf-8?B?bU5XZmpRem5jVGdGSTdPUlhNdFBlRXlTdUpMejJ5czh6R0RvZzh4YmRPNldW?=
 =?utf-8?B?ZENwUFpSVnZ1UWNOZlJwK0N4RGltczFWM0pZMTR5UUF5dVFCclZlN3dCTWtw?=
 =?utf-8?B?RUg1b2ZXSm9KbStTMExid1dPYmROSWpVTXhMNTdqYS9QMEE0cEsxNGJORWRG?=
 =?utf-8?B?ZWl6d2FmaGU3V1c3akFSa0VVaDlUUEhUUFFiWlJUaThLM0pjZkRxSDdPTzVi?=
 =?utf-8?B?eVB4dG9aTHNmUStOMDQ5QXpPWHg5eDNuOGpVUmFkaFgxMUt3WGhOQnFxTENp?=
 =?utf-8?B?MDBmUDFuVlVNbzJkTzl5cnhZZTkvL2pxTXczOXArNVl5U2dLejJGUXZEVGI2?=
 =?utf-8?B?RjNBOW1LSG1BZnFGNHNicmErN3dFbkdsRHBFYXJzYW5mUmhQKzlmcHFHNERD?=
 =?utf-8?B?QjdsMXh4Tyt5K0taYlNCKy9zSjFVV1ZvYkhaZ3lBRXNjOSsvU2lsRE52UHU0?=
 =?utf-8?B?YnIyMnlYcHpIL2VIM1JraHY5VndnSXpNNEF6bytRT2JOTER1ckU0M1dSdlJq?=
 =?utf-8?B?YmNMa3lGWXpQR3dSU1NJYnc5SmQvQ3pmN0x1WG1VQjU0UXJucnBNNHl1SjlV?=
 =?utf-8?B?c3Z5dUdIbWtWSDFadkNUSUF4N0Njb0RzSC9XZTdnOGJEdit2QkN0T3k1ZHda?=
 =?utf-8?B?bGNWbVRNMzlFd3Q2MVc3QWRUN2xIR2I5ZlpqVHlCaWxWUVZ6S1BBd2ZhV1k3?=
 =?utf-8?B?U1YxV2hTSCtLL09GMFYxTm5aZ2xzcjFVZkZqdElVR1l3eGZaVmcxSXExU0pm?=
 =?utf-8?B?aTJqczRjakhSalFXTWpYZzNPQkVXK1VwbnNpU045TDVhMnZvY2VvM1dRZkk1?=
 =?utf-8?B?N0sxM3d2dXVFM21CWUs4OWJNQjhMcVJraW8zdWJTMCtBRFpZRW5TREtqQzRB?=
 =?utf-8?B?VXBEYThaZUJCU3JaMEtZMWVUNHNFN0tobEtuZEhPdjlFWFJpdC9JQzRKcU5k?=
 =?utf-8?B?eXdkUFdHTkdPQUtGb01TcXVHQzdRcy85T29yMXUxRmdxT2t0YWx0K290NC81?=
 =?utf-8?B?TGpPOU5ROHpYbzd4M3NwY2FmWXNtcTVrUWJ1ZG5JNlVyM0QzS3lvQ29JKzg1?=
 =?utf-8?B?VkxTM0JaQ3cwOXNMdmNDdDFta29FNWlFZGJ3ZEZ5VkhTaWZZOWx4NkZ3QXZv?=
 =?utf-8?B?UVBQazNFUGxNYUFTS3k1bjVSYnFQMmlWZUxPSm9Gak85WkVGdVRaWmdnNGVt?=
 =?utf-8?B?WWdrdWVJYVVETy9ubC8wUUVrUnFjWXJRQW54Z2t3dkxLV1E9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OXY0OFVuRjJpUXNERThrS1VSWjNZQ0dMT1VXYzFiT2pyM1NNaGk1NCt4MlR1?=
 =?utf-8?B?L1U2MjdUZ3prL3pWWDdDa2RlcDVFNmFubkJsZFdMSHJ5a3RIMVd0Um5qSHZU?=
 =?utf-8?B?S1B0WlJvNHYrQjVUbTkyeE9iL09kbWsyZk4zMWR3UnZYVitSd3lvd2J0S3k3?=
 =?utf-8?B?RDlWWE8yVXc3TTk3OHQ1Y2owdWFwYytVQkJ0RHpSd0daMllHeWF0T2dkb1NN?=
 =?utf-8?B?Ymg3Y2tYK0hYK0Rja2VNM2JPMDhBRWIyRnZ2cGZuMlFYWU4zSXpqREZWaEgw?=
 =?utf-8?B?RnZ5bUlScjJjNm1WQk5Mc1JTOCtJUlFvRUl1MDA1WGJ6L2lubW40SHByN0VE?=
 =?utf-8?B?MUhkQklVTjVyT0FkR0NjV25raWlkcWEwK0JXWnc2NlhJVVc2OWoyRlV5bTJ1?=
 =?utf-8?B?VHFscmxDZEZNa2dhN2RrbU0wOFJ5VGxjRW5Bc2hVTk9rMmxRd1BnM1N0cjNM?=
 =?utf-8?B?cGNUNmNBc05jWldDV0J5TFhLTHhCNHZLR0NxTGhuZGpDd0xwSzJlZzZTTHpU?=
 =?utf-8?B?aXVTMEtuZ0xOZytEQVNYU3JFajZubXgreWxYcGU0SERuUGNGRVpTb05xS0Vx?=
 =?utf-8?B?Y1hwRktIbzVsVFVJOTNRRFVYRnpiV2psdGI0b2ZjNDNiNnhFYU5NUndrY3Jw?=
 =?utf-8?B?a0tJUWxFTmpuWmg5TWIzaS9KRDhhM0xZcXB5dFJEK0VlTU9KSW9lYjNOamFp?=
 =?utf-8?B?NGNER2xIQWtqaXZTdHBhanNpaDVsYnpWMWZydlF2YlY1SitZTkNyNHAxb3NV?=
 =?utf-8?B?THNjd0pyUmVOV2xwV1F0ZVFxNEZWKzZhZVozS3IxUmVyT3dGZXVpQ3A0eHNP?=
 =?utf-8?B?VTJoOGNJa2l6eHRGS1d3cHhZT25sVFRwRDZVSkpoZnc0cHNDUndYZ1VnM0Ew?=
 =?utf-8?B?Q2RPOGhpeDFMbjJkRVdxeUZhQng0R1p0Q1YwVERUNFdnalVBRUZVL3lESm5H?=
 =?utf-8?B?czJyYmlMaVRYRFdXcDlWS05xdFlYWjNCV2NKak9LbVhFZk1lV0R0eWE4NGtw?=
 =?utf-8?B?a0VWdXQ0cjNOUFBKRFB3eEFVQUtoaFZTbUltaWFHcFNYbFdLdTBPdnplbENE?=
 =?utf-8?B?VUJWTUFBYTM5OWJmRTAzNW00aTkvVXkyUVlmL1BuVFpNbkMreWdHRHg4OHo4?=
 =?utf-8?B?RXhhQWVZTVdHSU9NNGtkc1VSblZRRUZTcDZLU05YcGxiK01JM1MzNWRLQzl3?=
 =?utf-8?B?aWtFTk1ieVBqYkFGMG1MbTZhYWt0MmYrenJtLytRK08xZ3RMc2p0aFN1cTNI?=
 =?utf-8?B?WEpOMnowVWUxMFpKcmJoVzZPdkZTWUtYSDNNWnRBTXR0M09OaFJ3cmk5a2I5?=
 =?utf-8?B?dFZTVTN1RnpXVmxEczlGMTlkNjB4VGpOdGlYZDhQMzNBbURxeE9vTEZuNG9F?=
 =?utf-8?B?TTgwckRNM0VCdUdmNWZ6TU9CUzY5UlJQd2dybkFvSEJhbnlUVUhOaTQzRWpi?=
 =?utf-8?B?V1B4SkVkUVhiWnh0VG1IUzJBVlpQUSs3T2VRcGdiRzdRZEFPdWhQN1VZckx0?=
 =?utf-8?B?cTJmRGUrTGZnOGRKR2pWaTJKdW5TWk5pcy9VQ3BXQjlhS0FWZkFmOXI2MUxr?=
 =?utf-8?B?dktFQSt2MTJTRDY5M01kdFJ0SnZCSkNDcm1LN2thaGFiU1IySFNHMkFKcFB1?=
 =?utf-8?B?cmRWeEhYQ0YyQnFkUUZ5bHpuV25RQndWSnNCSENqa2xHTFAwKzNYZFVVeGg1?=
 =?utf-8?B?YmtuRGR6MW1tQmRyV0NVWjlpK2hPTTNEL1hSVlhQSHEzUnBxTm0zTjdySHNp?=
 =?utf-8?B?NmltUjA4eHdTbVFjZjh1ci9NQkFhYlFjT1RnMkRRdi8rdmV5dHNSZ1NwOEcz?=
 =?utf-8?B?aTNNUXZqQVJiRnoyYndSbHJFS2s4cE13ZFJhOFBITUlrNDF6QXJYRlFpUkp4?=
 =?utf-8?B?WWlXR01sTmx4TVlKVVNwVUlvNExDNzRFeGxmZFFJRDJpMkRDdCtFM3NocWUy?=
 =?utf-8?B?Q2N0UERCN09TZTJ6ZXJoSWhJdGtiSlJDaTJuVUVuVmRYUDFGZmw0ajh2VHhZ?=
 =?utf-8?B?TDJOYkRFUVA0akxNVGlzS0NMVG5lWFNPczNxb2xCclMwQWhhVG5vM2NRaStQ?=
 =?utf-8?B?WFU3NFB4SThpYkZkYUlOMEREN2ZqempDcENPVkZ2UWlLOURoOElBZkRxempn?=
 =?utf-8?B?ejdhS010b2pCQmlCSGhHanVTWWxJNFdwRTUwYnZiSGt1WW5wSEc3MzVxQ3R1?=
 =?utf-8?Q?43zmDx5TplPwj73kydq420od6UKcdGwb44KoAwoglZUU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <22744782040DDC4CAEFAACE27DCAA8F1@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 295fa57a-8098-42ca-8a69-08dd133faa3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2024 02:10:31.6327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YvkQuyPlM62Jyjn12NtZ8iqgD4wcoXThJj435+opwM7R06Iex8nkw7In/ObsMFo0JMstaIbVUA1DIhXLqn00iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB8612

T24gMTIvMi8yNCAwMzoxOSwgSm9obiBHYXJyeSB3cm90ZToNCj4gTWFjcm9zIGJpb19zZXRfcHJp
bygpIGFuZCBiaW9fcHJpbygpIGRvIG5vdGhpbmcgc3BlY2lhbCBpbiB0ZXJtcyBvZg0KPiBzZXR0
aW5nIGFuZCBnZXR0aW5nIHRoZSBiaW8gaW8gcHJpbyBtZW1iZXIsIHNvIGp1c3QgZGVsZXRlIHRo
ZW0uDQo+DQo+IFByaW9yIHRvIGNvbW1pdCA0M2I2MmNlM2ZmMGEsIHRoZXkgd291bGQgYWN0dWFs
bHkgZW5jb2RlIGFuZCBkZWNvZGUgdGhlDQo+IHByaW8gaW4gdGhlIG5vdy1kZWxldGVkIGJpX3J3
IG1lbWJlci4NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJu
aSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==


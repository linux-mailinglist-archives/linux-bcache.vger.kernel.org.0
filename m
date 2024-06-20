Return-Path: <linux-bcache+bounces-681-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E11B90FC93
	for <lists+linux-bcache@lfdr.de>; Thu, 20 Jun 2024 08:14:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6CEE1F215C6
	for <lists+linux-bcache@lfdr.de>; Thu, 20 Jun 2024 06:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8579C3A1CD;
	Thu, 20 Jun 2024 06:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UhXftqKG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="cMdLppfD"
X-Original-To: linux-bcache@vger.kernel.org
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE6538FA1;
	Thu, 20 Jun 2024 06:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718864042; cv=fail; b=hhA+DvcKy8u6p7RRrqesPBsjo8zffnriC/Uqnw75PnBCwJ6oYg/Rl3jJXCVuuoe+FUdaUqKnE1iYWmwfeZISzKOUgcelL5NmmNUFAjPr0Mc7pCHEuACwN8GFLP7PWybdvbkwZqGhBcVaYlrvZ/N8QRI+cD6YwpNayhHm5u4JRVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718864042; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PPCBaWn4KEQc1UkB+2w/qFmeptgzbJ65E3l7iNSR0cw8otRk+O1Fp03fuIjcCjFpDDLwz8hXQ4qgE2ar0R4gnoDOr1ePsGadgtqCFHaXopGXRVCxNV6Mzs0v0u1IZ38J6wUg1fqiucBojXYEzo8BfoWqvSOmVHM481BfQtV/hVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UhXftqKG; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=cMdLppfD; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1718864040; x=1750400040;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=UhXftqKG4zX/3NFoxQSJisKvvpHTKsmtV5Kl9aI+WlFvTV1HQdMZU93t
   +z69NO77455tR7G+0UH3iYRmWZcmVRNEFwsAVrILDOc03WnLvGW6XWhQ0
   +YEK/irgl+xrbbYoPyw8HXeU7hqEcH61EgI5Ll0jFHKUdRxL5ADffvxIa
   ux417X4Lp7FdHgE+1pgqXErNr5ptbe4oHIerCnzbQ13peVdONy4Aaaiwg
   PP+OBJESmWPQTDWOa1gUz5pLlXKPe5B07ClxHJ7DCOQX7Etr8+PtCW0v9
   nOUHynrkUKGBL5Om7A2HdZxpwjDhOkkmcHICjwMxaqIKmAWbwUx8e4UB0
   Q==;
X-CSE-ConnectionGUID: URS/yfjWTraUkBsImhYm/A==
X-CSE-MsgGUID: qSGrZOmlTYG/e4Z1ZRiNjQ==
X-IronPort-AV: E=Sophos;i="6.08,251,1712592000"; 
   d="scan'208";a="19282358"
Received: from mail-bn7nam10lp2045.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.45])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jun 2024 14:13:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qz/rPfMvWKIDOQBR+8yFXVrnXlMcAZzKQxqNPyQ26aCPKvy404T9ApjcJVcBz/tp9AftpWqk70rBO/Nrf+HOkh2R8WsF64GFO+/Ui2/Zb+EYjfL6vtG2SRa0Rv8A88GWBwLrlDNb807i991WIIc6Iql3UX4aY9Nq1vGkZv3JRNm4MzfMaccQhFU8tE9aV+yZkMNXIoyZIO0xJiUdwjodCC3OsZHQe6nAvoGB2JuR3ebXHidhF4PHFixZVTgthavummqn831ngaY5lXbgFsMzqx5T+TgrsurIrFsXSfFnrq7sEzUWmQSKd++mXXsOyyaeLsUK/o/kFbfQec4QzBfY4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=SoiCKO1W+Unj0WbVEA0wZF6SYP4mmXkCXVZ0c4l2es+fz18YKUrWhuwXY0Vh2VjrePCYNHd9touBrNxE78mF1A5knYusBLrMYU9hce6XjWamAkHuVfOZVx0dMZnnjrZQLZjGaflt+Kq/hgP9n69xXoK2wGNYXud1velPhA5e0ZHGFCx1RW7mfjiQSo0ZMZ1pGJVBIFPuGc6Scqo62O7c38reTqVexXDX4O35AviX44pw/NcaL9xSJVWyQlFVPigdZPlEUVScFkL3fUPFYeKi8xksrF6Tiy9NsjqVdlfgqlViOyiTpeNwgpFusfSI+jk57sPPw93Or8SFKuDdzCLX4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=cMdLppfD5yjxWQUQSCitAauXitQwRTlZCVxmPgmpgecNLqdQn91WZLrJ6+4xQ7hUxF8rTzWoVeBRKWOit9Fa0tQ8XtxCpY+ETUvrBRMKU7g7oFzUgjtY4c7LPwKbGSJQj3PW9oTaI/WD4XPi4ooz/OQpdiibhTt8USGMCFBgMtk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB6764.namprd04.prod.outlook.com (2603:10b6:5:24a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Thu, 20 Jun
 2024 06:13:50 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 06:13:50 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: hch <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: misc queue_limits fixups
Thread-Topic: misc queue_limits fixups
Thread-Index: AQHawmF7OgFl4PRc4UiXpzvC024eT7HQLUYA
Date: Thu, 20 Jun 2024 06:13:50 +0000
Message-ID: <7422bca8-ca30-4940-8e24-ccfd761c693c@wdc.com>
References: <20240619154623.450048-1-hch@lst.de>
In-Reply-To: <20240619154623.450048-1-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM6PR04MB6764:EE_
x-ms-office365-filtering-correlation-id: a629678b-4395-4591-21a6-08dc90f02768
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|1800799021|376011|366013|38070700015;
x-microsoft-antispam-message-info:
 =?utf-8?B?YzRrM1h1ZVM1VnRtSDc4dDNlN3E3c3laQ1l5d2FjTmVsNGFjcWt6eDcyWFBN?=
 =?utf-8?B?VVFxaG5Fa01RTUVUL0RndzdrU3NnU0g5NkY0YmxVczdHVFltWEJoRGNxV2lk?=
 =?utf-8?B?Qkk3U2NhenZkV0lMcTdOMXl5RGMwNXB3NFpaVVRPekF3WmUyMUs1ZjB0QUNP?=
 =?utf-8?B?S1NHNlJYZ0ZVUld6UldtRHpuUlpHbElmUzF1aGJOdVlDWXZjMjhXc0Q4SUp0?=
 =?utf-8?B?d0g2R3FpV1ZnN3JKcEFKZWtkR1RsRUROSFFHdTBpbVJtd0JCR1YwUTRpU0wz?=
 =?utf-8?B?UkFnSFFSYzE5M3dPWG5MWFl6ZnFEVy9sY21ZR0hkU0VzTTAyRUdjMVJJVWpl?=
 =?utf-8?B?dHVZWk10U3hHOXZtSHZlTERSUmczVXpESFRBblNtNkNtSVQyMnFOcVhDdXFp?=
 =?utf-8?B?Tm1ILysrRGJaakdCN0tsSFRpaVBBUGlTRi80ZTIvZ1lJK0E4SE9JOFE1SDNz?=
 =?utf-8?B?djNNMkVGeEE4cDJwUE5PeUdkNWlBU0FSMTduVlY0VWtOTGI1ZHBabmxrUDMr?=
 =?utf-8?B?WGZFU3RRWGFjM2NTZUtGeG1NY25SNGpBajMwZDMwWUpuQXVDdFRzVUMreGR5?=
 =?utf-8?B?ZkVWR1NkcUJnT1VadzdlTW1iREREK2lzR2xseWZiclR6U3FkdFdjSWZOR2dm?=
 =?utf-8?B?eEVIbHNEeVhUQjEzVWc4QThPak91eHEwK2grSkJvOVZKNmhrWTNoTGgrSGZD?=
 =?utf-8?B?WXZLN2lqRmNVL2FCY3p1SHA4MnUwVzdNSWd5S2xrbjFFSE5JVWdLdDI0cjgy?=
 =?utf-8?B?ZFpwZUVXOWRRdzdqYWlqRjU4Wm1ScTFuamFZQVhjZC9IMTVqRWluMDZVZVBJ?=
 =?utf-8?B?RngxNUdRN0tNWUpqSDVITVlLb1NvZE5XVDloTHhJUStLdlV3NW8rOUNGTFlQ?=
 =?utf-8?B?WEp3dWE3aDEyQXFHa0czWXUzeXpVZWY0d1Yxd2VnU1dSdWZ1bFJPaVJzUTB4?=
 =?utf-8?B?aVVSSlM5Qk1yVjBrditUdUZhcEc5bHhGdnlabmMzTlM0QWVnamNsNC9DYXNL?=
 =?utf-8?B?Q1dtTDRSWGlldURzd3R1RmZtTVhOZnNwcDQ3WVVqY3lETTFsdlVUb0FwenUr?=
 =?utf-8?B?eWJSV2Z1QWlYUFUzKzFkK2V3WXhJRGFKZDlLQmFMcUxHb012VEE1UkpscnVo?=
 =?utf-8?B?VHJoRTU3dUd1UVkrWjJMS05ZQ3Vvd2QwaTZ0bi9ib1YybWZoUDNMVGhMenNB?=
 =?utf-8?B?VWlmdWtuQUJRVFdINzZ2SGp4SGt4cmpNUXRDeEVvVnNCVmZRUlJRK1k2TnBn?=
 =?utf-8?B?enlndjF6TGJZaEh2eVh1MjhJeWZrYzg5Ym52T0MwdVY3L0hZMWdxQW0yWW5N?=
 =?utf-8?B?ZnErd3F6Nk9RQmZlUjB5TDMyWlJiODkyL1FXdmZXd0lrOU4xOGFJNlZiVTFi?=
 =?utf-8?B?UEdCajBuNGNaaUxwQTg3OWlJZURWU2RjQmd0RzZZMnVpMmRvRm5lL2RCUjFD?=
 =?utf-8?B?dXJQSlRWRUIrQWl4R1dXMDNDdk9JVmlYQTNQRnc0c3NkRkh2RkMxbnY5VnBJ?=
 =?utf-8?B?cVcvdENVaEhjVmU5UGUzWHdTNTJUL0x2eWZDYXplSkFQSzRwVlE5eDZ2Qnhp?=
 =?utf-8?B?UWU3RnRQUkRFdEg0U1o1YzVSVEdET2xuRjhPRUpiaEZ2NFpyd0hZeGZGSE5M?=
 =?utf-8?B?UjRwSzM4Q2lvanRzYWxTOFh1Ny9oWTR6ZmNYbEFIU05OenkvQjVpeERsSnRk?=
 =?utf-8?B?Um56RFpZb2p3MHNLOWtrTEQxakVRMWk1RHJzREJ6MEdZbVZXMzhDaExxRjd2?=
 =?utf-8?B?eWxyQzQ5VjN1MTRieHN4c3Y2T0xWa2Q0RlN6YVVQUng1OGFpaCtwTWU2cUtm?=
 =?utf-8?Q?OV6dilQC3QW1+b7buuoixWSxh44ouBwRFzlbA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cHBPdTBiWURSQ2VROXNLNE4wcksvYldReTdnbm9xTnBkR2J5djJXZWc3aGVj?=
 =?utf-8?B?ZmtTb1l5ano4dDBqUlFLbE5XZ05leWw0RHh2eXNUUTRRNEpVakhDcjJkeU5r?=
 =?utf-8?B?RCsvVWpYWk0wSEFkK1FLU3U4NmdxbDZuRkNML2YzejM4OG9CaHNmYXZVLzhE?=
 =?utf-8?B?bTNIbHd2UXA1akRCb0Z0OEhHdkdlelp3YVJZek5yQjAzQXhQYlk2bWlqbDdj?=
 =?utf-8?B?S0xFWjZkWG5zN3B3QzJjWnljS0tPM0pUTDVlU2d3MGdvYWJaeWZScTh5OGJw?=
 =?utf-8?B?TG9mNzJTWGdBMzhGNDZlMFVhM3FkaGZoY2c0Sit6YncwQ3hmWVlpalNpVkZG?=
 =?utf-8?B?UzI3ZlMrVDIzN1ZZblRUUEtnQmhOQlFnSHJ0OGpPWVlhRE1mbDdjNWpXZDNn?=
 =?utf-8?B?N1dtb2txV3BWYlJhM1U1WG16UFcyMVVIbmpwZDdsQWFkeTlPTUVtT1pkUmpP?=
 =?utf-8?B?Q3BoNlNESUw5MENhWXYyaXZ1Mnpzb0RiNStOeDBiUGEvVUZ1ZStkTlg1VER3?=
 =?utf-8?B?YlhoeitCUVd6RmppUmwzcC8rQnp5YkZNUWJaaUZ1NCtPSnJLT0w3Y0xrMGk1?=
 =?utf-8?B?Z2s0cG1MVjJRUzZoQnFzRytsQlVBdUZEMU43UjdLeFpRRzMyRXo2akJnQzZ6?=
 =?utf-8?B?RHp3akFHZ2s3TnoxTS9qc1JvdlpLUGdob3I5THVzTjlJbk9DUElkRjJRSXpj?=
 =?utf-8?B?OGg1Zm1hSmJNckZxQzZCUzZ0WkJwVVlEaHBtdUo3VHBjQXVud3hGM0lQcCsx?=
 =?utf-8?B?OWxrbXY0QUlpRzVwZ0creGRGaGRGYXVPSzN6YlNDWm5RbXlqc0YrM1A1UlB5?=
 =?utf-8?B?S3V6WEt5dDMwUVNQR3FwczM1OUZ0Z2dSZjNjTEZFaGtTbDkycDhPdmtuVUg5?=
 =?utf-8?B?aDNUbjdxcGF2cG1PZzNUNWNONlNSWHF5WlBpVExYZzhVZWpjaTRYQmpZOUNt?=
 =?utf-8?B?UEtmRG5ZMFl5K0RjVHFPbFhlUHcwc1ZVdG1sQklkcXJ6V1dXUkhtN0IzMklF?=
 =?utf-8?B?NkQyTjhieUFmWmk0bkFjN0xBd0UzbHJpUGpLWW90Q2krNU1Zb1V4akdORHQ1?=
 =?utf-8?B?R3JtUXg3eVcrc3BOZ2VUV25mYkVOWHJYVFdvTExFaUFVb3FVMDg3eGlqb2Vs?=
 =?utf-8?B?RjFIWkUrZUp3Q29EeWlDemdSZC9NbkFDaXhVUjc1U2FqU1hKVXVmWmlFVDVE?=
 =?utf-8?B?akNBcjZlWFhJR1BydkQ0bnp2eG5JQUdVY3dzRTI5cGlReFV4Z3hpMHdMcTdS?=
 =?utf-8?B?TXBINHZzYXFEK3Q0Z0lPUktmQm5ZNk04QS9sTnRnc3QzWXM3dDVENXphNTZk?=
 =?utf-8?B?NGd1UGE1SE51RFZtL0w1VWpOWEV1eHF2ay9nS0NMaXdLM20zbjVuNUZQbm14?=
 =?utf-8?B?WFA4K2JkeGd5bWpOY3dnOE55MkMySStCUTBrMk5VQ25ud0l2Ynlzd0MxdzNN?=
 =?utf-8?B?SEhjSmVMeVZHdlpoV1dMZlBsakZIZ3R0WUNNYVExNHNCQ205eVE3c0JGNitC?=
 =?utf-8?B?czRzMjBqa3N4NFI1eGc0aFNjUHlHZnpzM1FkSFFSbjlVRGs5NG8zcnlzays4?=
 =?utf-8?B?V01rSWpiSUY4WGpJZTNPYTZkeVVvZnVPS253aEVMUXh6RDc0b1dXTVZlRVBw?=
 =?utf-8?B?bk5mSk5uQkNoeEtyNlA5d2JlZEdyaDByWWxSMWUvVDBkR253Zi8vcmF6SUpM?=
 =?utf-8?B?RlVjT2ZlVWNXaHE2TWRDdW45V01paTNORGJ4ZEVITTlaMUlReHlnMUVhYkFB?=
 =?utf-8?B?UWhvSkNkUFBURXo0MnkyTm5yUFhIcmRFazVnbUZ0U0pIOVRqTTJRRzQySG1r?=
 =?utf-8?B?UERXQzFvaWtibzJoclo2dnJxR3RvQVE1b2ExYjIyclhmSmZNK1lrYmIyZjd3?=
 =?utf-8?B?MkJRUVRLL2ZaRGQ3VmkxWjJGeUp4TFFyKzJ5M3p6alFpWXRSbmlsWXVQMG83?=
 =?utf-8?B?UzE4VEc0NjJGQ3J3NVZHajBKRVVWR2FEd3lLbjAzQzNwY0pkbFZYZUR6S05F?=
 =?utf-8?B?ZmtmN2FjV0orZUwyQzhuSUpFSEVrRzJQNy9qYXNSL2VjZ1pjQVB3eXFDdTJX?=
 =?utf-8?B?Y0xVYW14ZUUyU0toN05ydG1EbEIyL29IOEp3d2w4NS9aSlFJRlBldHF5Ry9y?=
 =?utf-8?B?Yy95aExFT3UrWTVyZjVUNVFWeHlYSnNRdnJqbERPNjRUcURWWDFycWc3RWJ0?=
 =?utf-8?B?TmJON1Y5NERlTlB1aG04UDNzbUVtSVlKRUVLdzJrWFkxR2J1M2hwWnY4UEdL?=
 =?utf-8?B?TEoyRzJDMUpqZk13dkhFRWUralB3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <389F022FCA04C34D83C626E026699A8D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J0ZPbQsfJqW1IVDSwbdPcGR42TPJMYRAATdEyLZuwfAYn8VKESOBlsh33IxhELI+yGuoczi5dDAsSEDtjbfk7OOehxzldUJQEsJJxpuPv6oY4RWK/s0vTPR3qix8mTA8TiWAHhdv0YJj/1l+HP2krD5OWcPzFSafjNkvlqJpmobDsIJIy+PgGCXnVC0PPzusctcLMi8+9lT4UpekHT/M1xIyVGuTWarey4Dt385jd88q2H58o1hJAaB7t16yTbyYIkPtSd+Xd+wmdkvMmEIgdCNc2eiKp+WtEEcZiha4LibF/U51WYhzVyybSQmPiN1sNAgkwIylrtWExMbma9Yx9L6ESCxLv8fNB+PC/PNvqXZBeyI0QZN9DH/RiJ9tjB8HQeMsURgxM31Ag38dDCHRk1XqF2mOBCkaUx7htmDzu8pVCQ2yVTnrk5ZNqdP4jpTEhrcV31/ZHxV7/6csNb9ADkDT5MvNfhGRI+VaBu8oeBk+21LGYVI6Xi6xruaYP+47Hk3dgwN/icJpI+fg5wqerTwJ4YM+XRSM3tqu9buscEQdC+5sZ9yRNUc7iXBKYFF7f9Vwcg9nO/nXJ8rXMdc0SAlmMExylfJEoXaU/PDG6GIgpaG6O4qiDGV5NyQoPDjl
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a629678b-4395-4591-21a6-08dc90f02768
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2024 06:13:50.7167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M/1VyxoXHlo5xlAQUgeC47lAUJMbTE23hrafUue1ghIEvl0dRRGiDXtms1w16EIOm4SW1yYiIdDsx0HZsJMKplk8ON3By5XI4CE3ypecZCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6764

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA63D1D6E47
	for <lists+linux-bcache@lfdr.de>; Mon, 18 May 2020 02:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgERAgU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 17 May 2020 20:36:20 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20395 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgERAgU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 17 May 2020 20:36:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589762184; x=1621298184;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=w+JMqPBC3GCerZ8TjdMEVXCzRbI2p2LZlCMS8Ofok7c=;
  b=EZwPOxLeDxSqC2hROXhUqQ+e/8PGNeYAAAyEMBt199OtfREg9zDCzZYg
   o23cgsw6Pxoo3v/vwMhopy0nUmlwxgYUM/dxRZLkoMfVX4egW4A2Cb5vk
   DodaVGHtPGa7ToBGo31BuK7+KVmlvTsIQH9W4LDEq+5PozEJLdfz/tTxa
   4gX+mpTeQ0zm+hOs49mSwN6ebVy1aMKPsiZcMllCp8226mqsTd8+5jm44
   ZfysIF+PZ/bTKoDDcFE3cyp4omkN6BzYfTSSsTVjYL1yqtMygv0yHexdF
   /eJIc5SKG21Q9q/onaBh6QnO+Ty5VcOj9unpvNEbzNy82OwRyK66s0sWL
   g==;
IronPort-SDR: /l853z4Iw2dZqyiAfslHhgCDmWucCGJzAW4uSl+PUcmpKtr+yHPg37kZ1PKzkeKOF+KGevRAuk
 3Y7EccYbSj116htt7lXt/qK3HcNcP6hJp1mwFe7OGx7mFRUnWPrCVbZnsI5Kb5HPY8Nq1yhm44
 Iuk6l++z90ysMr2I7ls6kkYC0+r4ofRrWB1fplPzDKaQLxYtcqFSiH2/ylXTTqfG2Z1kBxkLKp
 R2ppKglo5UNYqSmux7pXOIyCn6eDZiyDXxh9FNnMB+RZnX1A3Aia2cGsMewGgEdAUIDsupHxdy
 vTU=
X-IronPort-AV: E=Sophos;i="5.73,405,1583164800"; 
   d="scan'208";a="240633926"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2020 08:36:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CoaSsFxuhKg0NhJTW2xaevKK73igV6fYQ/9GIVp5MkbS4MM1sY2ryZClL4u5YYHCs78v7mPJ56vR/zcrfSG5KuFwLiosSFhxBv2G5FI5FIsy8bIKrZnS73yTO+yZEV5h2qxg5YKwtd8R237wI7ZTAqrjjSxWeRGLc4KppSc9m4Fme92bqFnf/pkIrR4EogmKVHNzuhNkILu0D7zMXCT3D9/CKIOLZTo4mZUai5ibO3q0djpGLPc8/XZV1cGEL2KeVxarhb0qMPQnO2zNS4ElAWHAT8TLjLg1mYpPDXu8NMOLld5fVAdFLlwAIUo0gLBvR4zGsDyAGdJEghDSnMptIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jg/djrX7XPUvD+4dojm0EbyORdYoaMU8VuQ7L5TecsY=;
 b=fmp+DrrCKdlcgdyfzuAlf2Wx29uEA6H2UcXFV3yTkgZy1Z4Mt13VsDKce69m14x7E8rDFog9Z+GTf/QGT0jeIURKccCJGZaHXPTXqjaEAP0S7Yd7z5mv+KIC1SBbzNqA9bm3x2LU6Y6Gou6siBU0PsKq3rC5t76q0fQwN+7aeK6ON/JHHzQNhXKGtKs95Wc4hcnqSF+sNlhX1LBdoRgQCfTeFGpqhaNZzqwMoTPO7hwZLbeladUXecl/xV4pJ7wcR7TsjuU66R7czE++usrF5KgUQ+ZbHrxMTBlC1C9c+rH6EMNlbzAIoPlQDbQNoKnUXbZpKqegOtk6BtGVznSt5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jg/djrX7XPUvD+4dojm0EbyORdYoaMU8VuQ7L5TecsY=;
 b=tBoAkrKK3E6suP5J0FKtykmUd6A7q6VdZi6/V+AKBGjfi4mSq4MOpv+lQVbsUNm5DB8vr17ZzSGhD7e/mN5E0r5C3c+dKN5FGA2AzWiQbBqLtAN31zbMPqMLcnvwBe8glxqbrQgpayvV8gjxu/VgxEoAPSKZKc5S3D5cY/nglys=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB7121.namprd04.prod.outlook.com (2603:10b6:a03:223::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Mon, 18 May
 2020 00:36:16 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606%6]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 00:36:16 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [RFC PATCH v2 2/4] block: block: change REQ_OP_ZONE_RESET_ALL
 from 8 to 15
Thread-Topic: [RFC PATCH v2 2/4] block: block: change REQ_OP_ZONE_RESET_ALL
 from 8 to 15
Thread-Index: AQHWKzXOPpTDsP8N30uRJqo6vyaXFQ==
Date:   Mon, 18 May 2020 00:36:16 +0000
Message-ID: <BY5PR04MB69005EDE7328EEB0FA78872EE7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-3-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 85137185-d4f1-4ea5-176c-08d7fac379b4
x-ms-traffictypediagnostic: BY5PR04MB7121:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB7121E1846F2DFFD7334DDE9BE7B80@BY5PR04MB7121.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 04073E895A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hS13Ex0ihbK+xwIObGktOBOP7FqZ5uhUTxQli1S1VlTMddJz73ZfAOM5nMrnLaKO3xGJo2lmCXZZMj3wx45vukAQX3K9yTGpuj/GEsmkdXVMbcp/9by2sjpRgafB1HR++DPDatHFJgeCJ0JWwgjX5La8VhU+hxlnsIOKt4b86Bab/40x7aSd6EhGQgyvHIZFVKXpCHtSXrbQeeXADCZ9sVPU2qcwxUo69CydaHCXWW3oAC8ofToo8oTImtQtsyjA3KHNfpuTYiceAmMkX5TVSpJVzOnvIXR4oK9t7hOT5jCpPH3uEnc8QVOOW+jJqnWQNgflTLwP3DmE4+UMalNB/6SxR71ePV5jflPp1Qr3VzsD20ENYVkjNP3ngFP6JAfjNzGMKkAXhnB+FkuSsxJBPq9cp3uqP7jyryr9jWsrR3RBn90vTO/Qd8vH2eEmL5m7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(52536014)(110136005)(54906003)(2906002)(316002)(8676002)(7696005)(66446008)(478600001)(76116006)(66476007)(66556008)(66946007)(64756008)(8936002)(53546011)(86362001)(6506007)(55016002)(186003)(9686003)(5660300002)(26005)(33656002)(4326008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xlNu0iCQhArjXu0NlG7nOAerQLwdxhd8RZeZuMoOSTYA9j3UwXizmdZXcZdaFj722kzxY4B8ozirrSwN0DMNJRjFJxUHyNsBz9lyqDu6FY1jZRMaql66yekWVNxGS7RXI2izkMXtGPq/ws5wB7Us8wK+yYg31jhfOl5LpccJfq2QA0EOeAE6/eOp/ol7e/z5seAPVZZxMsL1e1BJ4j/koqyfEpsYQNM9VYzLR9R5FlBWq3+T7JKSjMsiv7QZbfXCss5/032/zjvVHI3ikaMnMbKDZnYpzYSehhBmAOCWt74Mm2bxhh6fmnFlfn6i5l0WHDw4tXzN753GbGUE6W1tgfduJsSt5mOGE3Jd39TiArxFb/R3vCHDu+Z+jjGPDB3FnC9+/y/8q6nveu6cMDn0kASh5/PZETfCPXnNy7Yjm3atmNiKUM7WPk7RCSdYdpNWq67ROdSahSoF7+dJVB3jsWggEj4LUFggq/rOMVfcyhoo4O1DSSV5yz+iVgCfYHWj
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85137185-d4f1-4ea5-176c-08d7fac379b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2020 00:36:16.1934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SgDvEWXgnO2U/ZuF87sO2nMcrIzr3votqP66BCvOQXkTJ0rIeICTgzqe7e7LZutbMVzU3QvcTx63BOBOue3B8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7121
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/05/16 12:55, Coly Li wrote:=0A=
> For a zoned device, e.g. host managed SMR hard drive, the request op=0A=
> REQ_OP_ZONE_RESET_ALL is to reset LBA of all zones' writer pointers to=0A=
> the start LBA of the zone they belong to. After all the write pointers=0A=
> are reset, all previously stored data is invalid and unaccessible.=0A=
> Therefore this op code changes on-disk data, belongs to WRITE request=0A=
> op code.=0A=
> =0A=
> Similar to the problem of REQ_OP_ZONE_RESET, REQ_OP_ZONE_RESET_ALL is=0A=
> even number 8, it means bios with REQ_OP_ZONE_RESET_ALL in bio->bi_opf=0A=
> will be treated as READ request by op_is_write().=0A=
> =0A=
> Same problem will happen when bcache device is created on top of zoned=0A=
> device like host managed SMR hard drive, bcache driver should invalid=0A=
> all cached data for the REQ_OP_ZONE_RESET_ALL request, but this zone=0A=
> management bio is mistakenly treated as READ request and go into bcache=
=0A=
> read code path, which will cause undefined behavior.=0A=
> =0A=
> This patch changes REQ_OP_ZONE_RESET_ALL value from 8 to 15, this new=0A=
> odd number will make bcache driver handle this zone management bio in=0A=
> write request code path properly.=0A=
> =0A=
> Fixes: e84e8f066395 ("block: add req op to reset all zones and flag")=0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
> Cc: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.com>=0A=
> Cc: Jens Axboe <axboe@kernel.dk>=0A=
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> Cc: Keith Busch <kbusch@kernel.org>=0A=
> ---=0A=
> Changelog:=0A=
> v2: fix typo for REQ_OP_ZONE_RESET_ALL.=0A=
> v1: initial version.=0A=
> =0A=
>  include/linux/blk_types.h | 4 ++--=0A=
>  1 file changed, 2 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h=0A=
> index 8f7bc15a6de3..618032fa1b29 100644=0A=
> --- a/include/linux/blk_types.h=0A=
> +++ b/include/linux/blk_types.h=0A=
> @@ -284,8 +284,6 @@ enum req_opf {=0A=
>  	REQ_OP_SECURE_ERASE	=3D 5,=0A=
>  	/* write the same sector many times */=0A=
>  	REQ_OP_WRITE_SAME	=3D 7,=0A=
> -	/* reset all the zone present on the device */=0A=
> -	REQ_OP_ZONE_RESET_ALL	=3D 8,=0A=
>  	/* write the zero filled sector many times */=0A=
>  	REQ_OP_WRITE_ZEROES	=3D 9,=0A=
>  	/* Open a zone */=0A=
> @@ -296,6 +294,8 @@ enum req_opf {=0A=
>  	REQ_OP_ZONE_FINISH	=3D 12,=0A=
>  	/* reset a zone write pointer */=0A=
>  	REQ_OP_ZONE_RESET	=3D 13,=0A=
> +	/* reset all the zone present on the device */=0A=
> +	REQ_OP_ZONE_RESET_ALL	=3D 15,=0A=
=0A=
Same comment as for patch 1. And you can probably squash this patch into pa=
tch 1=0A=
to avoid repeating mostly the same explanation twice in the commit message.=
=0A=
REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL are very closely related. The l=
atter=0A=
may actually be processed using the former anyway, so the op number change =
for=0A=
both should be a single patch to be consistent.=0A=
=0A=
>  =0A=
>  	/* SCSI passthrough using struct scsi_request */=0A=
>  	REQ_OP_SCSI_IN		=3D 32,=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

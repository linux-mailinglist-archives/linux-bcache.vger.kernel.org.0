Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620751E0462
	for <lists+linux-bcache@lfdr.de>; Mon, 25 May 2020 03:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387973AbgEYB2P (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 24 May 2020 21:28:15 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:12142 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387925AbgEYB2O (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 May 2020 21:28:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590370099; x=1621906099;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=83KWXYcSLZrzBPMDc2eNd7FvrLAC1gHaOvoRn70rwZU=;
  b=Flw63ABhvawGqvtbtRgi7V1d/cd7X7YtOwGGFAvKHGzWTcjLJE7TLl1d
   Uj6JGGSgFyb19el2cWLoaETYUSulFB4UTkFKbrBGrf8ur+gHwbtxzJT1b
   X6thF+vx1Kx1NMBDFsRYjZLlGhnKHtsPowL22eUbxXEx0jXKogE6UerQj
   nTzjWhnDOmhsgGHYZAmvhimPvY9mdcrnn9EnGVGl8f1E8tOiV485pLRYO
   6UsupKDmA7opQcgJbQrvzSkbNoDUL8DUxiPeE4p7Boh4+YMn980GNjwfY
   Vgzx/tj0+ePvgD9D5SpNt5pSgWTbURr56KOuOQt8UKYh1t8UPVvnGPvGJ
   A==;
IronPort-SDR: n86oW6GsYtCL+BQ7qmCHSfGPDpSEiUQjh03zPMhRKokHDGu42gNeUVxu5BaT1OIs5XqrNf6Yw9
 eAO/RjTAFB0it5+JJODIEL0OCLuHDBlRli8ewENL81uBMoM4UbVnx3rlgIrtDKHVlf+LWJCmRB
 OF0akkRtONlu1NMe/t39vlUeLalsqBKXFYT3sQVJX96vBPBUfFgXhtC+bvVImLePPYe35BsLf7
 v7IinzUapxT2PrTJJgZ3wfApFzzDyx2y7t9Yhh4bv9YPMvTyFsmBXqx/P5MKBJsCQJwDvnaYQA
 Fbo=
X-IronPort-AV: E=Sophos;i="5.73,431,1583164800"; 
   d="scan'208";a="241212392"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
  by ob1.hgst.iphmx.com with ESMTP; 25 May 2020 09:28:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSaUKkYdgZg1uTsuX61pXT5qQYrdTtaDZiwxCYek6sFoqFFwi5KcuFh//tPKxnKlfRRt/QOi6Ji+Oql9BfjYqRXxSZWjVYmzTelXp9QYrinnbpcrNqHh5fLQp5h0eKOknLxJWhqf8zii6/UtzzeWuxUfgTun47B05eQ0isTxaiDv9MlN01KcdNvLb4BkH09T2oRIMOXypashmfwBF0jx2lsMcWMeUX6AZTPOWB53gBw39nQ7yn89IRm/PS6aHL3C3La0vbwHUHK0UlNKGD0225a6uRtBgbePG8NFStlqIf8Igc/JL5ppXvL3BH24PYW5pbNhsvlD5nmSd61mqdEo9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYYSRZR4T2PzMMWww3i0+tOAJUHxweDtSYl9lcxedKg=;
 b=CnK30Hpfpe6tbSmehvSQar/hXi+kFiyTvus/DW0C0WDhGqo0j5n9jCkAy+iG4ZpXic8518Vgerpy5fVgwMlUB9+rGr7l68s8eHEZxSyewYWYmtwd87b0+dsGVStu2Ln4Tw02PFR/Ib8XELLfowrTkTawTuWAWyuAECyrvsmkUKOD17K9NUJWtfSOlESPldiB8anqXN9tSS8hQRnz7IbbpVJJxatLElJbZeJQZySHD/9d800fb2mXYs8tU77QB5w+42anWNvEgGruEPe+zMqf/bx1XjI9l8J7srzuTyuZvWMYSbaMQgKq8STNuE6aW3kdqQjT06h4DcGOP38A9c9cCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYYSRZR4T2PzMMWww3i0+tOAJUHxweDtSYl9lcxedKg=;
 b=xpVySlLuw0dOpwg7CX19edG2OCepT7m5u/Nn9w+0+JQfJaTASAncLfbS3+Vz3Hc1dOY/EtEiTWQJoeFggMqTanrHqgSzc/10e8eHWjwejg97/SqgI48ODkQnxR66A9s17o3pTfUYLNWzByeqQo+eQBrf58eWi/nP7mUEtM1+QmE=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0745.namprd04.prod.outlook.com (2603:10b6:903:ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 01:27:59 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 01:27:59 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH] block: change REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL
 to be odd numbers
Thread-Topic: [PATCH] block: change REQ_OP_ZONE_RESET and
 REQ_OP_ZONE_RESET_ALL to be odd numbers
Thread-Index: AQHWMDx2BpgqYtXUvk21EEU09UOQzg==
Date:   Mon, 25 May 2020 01:27:59 +0000
Message-ID: <CY4PR04MB37515C060B07C147B14D7629E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522132309.112794-1-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 01a66033-8390-4090-b721-08d8004adbfd
x-ms-traffictypediagnostic: CY4PR04MB0745:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB0745A4A8FA08AC2D90C9C01FE7B30@CY4PR04MB0745.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4cI0An1cqIR6BMydaQDFmIvpnxDz1EYPhaA3OdYEK1FF31fmMb0l3Mi7t+KrfXkN7tGtGa5zxqSlbGFs01+9lcf8Pd9w3PEjvqXH6P4Cu+8Ge8Kqw7D3O/F6hY2+g6P8hZs5dx2vyEI1UAG7IhbvCSxR2uV7rHYLHfQ/B2/qaNP76G1q3od39RvE5RrMbCHZJZgsy8KP8thrXXucIEu03xCoNHDrrZOlfB+FXlqfZFcaw1B8F/RSGL6hks46vb/mOU8TZkQqiUdrMDi9uHjCXfOw1nR8DztYgT8hueHOJSOxJ55846UJkDIo2WMVsyFA0ItqBV4pLN04SjT/OwLIWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66446008)(7416002)(52536014)(110136005)(54906003)(66476007)(76116006)(91956017)(316002)(66946007)(64756008)(66556008)(9686003)(478600001)(4326008)(55016002)(71200400001)(53546011)(7696005)(186003)(86362001)(26005)(33656002)(5660300002)(2906002)(6506007)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: CUfmiegGmrseq95qwHnk4uXJDOe3W390qmnU5IJa2K92QcDkdvWA6Hlj7PM41le2Gy13tSHpsAzG2e5ZGKKDyO52jd7mmU6n6f9qM6HPigAg6n7BjKrHmY8kaL9jCktrN6Qcc/piV+uL8eTEUoHSYAc7MTvf7+iaw3IZOwu0exLHWGLn3F5diumHVPyj6oC9tNGnvf7CisT1Xr2RrjqWxnSq3xQlGWACcrjPLjnrOACkso1DVcHIswaual3Qum7ARu5SSiCIzwxDaq+fJrqiaPRUHjLZON8XmiGuJXKDmrdwq4Qbzze7jX22JPfeVIxflysWDdwdPiB4IOddJ6WgIfULwH7G7wPsCiLme27L5umPNTTpYbEknyJmD13gHkG0MeWY/D++00UVYroLSQnljmhX9Fm490E/yiHeeuNIHQWRVEYrlj5gkm/R5t4YxiMmaXwZU5tbZYpEwV+fQ/RcxFwbCJs8bDy1NyNzGh3Vg6E=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01a66033-8390-4090-b721-08d8004adbfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 01:27:59.0743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kjNX7UlVQagGNfSi7U28NVGhm9wUuLJ4lTfBfl0Q0cpyUSTFZWOdRpw+NDyYaf/rY9I5LjZe9VPueiDdjNxYtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0745
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/05/22 22:25, Coly Li wrote:=0A=
> Currently REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL are defined as=0A=
> even numbers 6 and 8, such zone reset bios are treated as READ bios by=0A=
> bio_data_dir(), which is obviously misleading.=0A=
> =0A=
> The macro bio_data_dir() is defined in include/linux/bio.h as,=0A=
>  55 #define bio_data_dir(bio) \=0A=
>  56         (op_is_write(bio_op(bio)) ? WRITE : READ)=0A=
> =0A=
> And op_is_write() is defined in include/linux/blk_types.h as,=0A=
> 397 static inline bool op_is_write(unsigned int op)=0A=
> 398 {=0A=
> 399         return (op & 1);=0A=
> 400 }=0A=
> =0A=
> The convention of op_is_write() is when there is data transfer then the=
=0A=
> op code should be odd number, and treat as a write op. bio_data_dir()=0A=
> treats all bio direction as READ if op_is_write() reports false, and=0A=
> WRITE if op_is_write() reports true.=0A=
> =0A=
> Because REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL are even numbers,=0A=
> although they don't transfer data but reporting them as READ bio by=0A=
> bio_data_dir() is misleading and might be wrong. Because these two=0A=
> commands will reset the writer pointers of the resetting zones, and all=
=0A=
> content after the reset write pointer will be invalid and unaccessible,=
=0A=
> obviously they are not READ bios in any means.=0A=
> =0A=
> This patch changes REQ_OP_ZONE_RESET from 6 to 15, and changes=0A=
> REQ_OP_ZONE_RESET_ALL from 8 to 17. Now bios with these two op code=0A=
> can be treated as WRITE by bio_data_dir(). Although they don't transfer=
=0A=
> data, now we keep them consistent with REQ_OP_DISCARD and=0A=
> REQ_OP_WRITE_ZEROES with the ituition that they change on-media content=
=0A=
> and should be WRITE request.=0A=
> =0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>=0A=
> Cc: Christoph Hellwig <hch@lst.de>=0A=
> Cc: Damien Le Moal <Damien.LeMoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.de>=0A=
> Cc: Jens Axboe <axboe@fb.com>=0A=
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> Cc: Keith Busch <kbusch@kernel.org>=0A=
> Cc: Shaun Tancheff <shaun.tancheff@seagate.com>=0A=
> ---=0A=
>  include/linux/blk_types.h | 8 ++++----=0A=
>  1 file changed, 4 insertions(+), 4 deletions(-)=0A=
> =0A=
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h=0A=
> index ccb895f911b1..447b46a0accf 100644=0A=
> --- a/include/linux/blk_types.h=0A=
> +++ b/include/linux/blk_types.h=0A=
> @@ -300,12 +300,8 @@ enum req_opf {=0A=
>  	REQ_OP_DISCARD		=3D 3,=0A=
>  	/* securely erase sectors */=0A=
>  	REQ_OP_SECURE_ERASE	=3D 5,=0A=
> -	/* reset a zone write pointer */=0A=
> -	REQ_OP_ZONE_RESET	=3D 6,=0A=
>  	/* write the same sector many times */=0A=
>  	REQ_OP_WRITE_SAME	=3D 7,=0A=
> -	/* reset all the zone present on the device */=0A=
> -	REQ_OP_ZONE_RESET_ALL	=3D 8,=0A=
>  	/* write the zero filled sector many times */=0A=
>  	REQ_OP_WRITE_ZEROES	=3D 9,=0A=
>  	/* Open a zone */=0A=
> @@ -316,6 +312,10 @@ enum req_opf {=0A=
>  	REQ_OP_ZONE_FINISH	=3D 12,=0A=
>  	/* write data at the current zone write pointer */=0A=
>  	REQ_OP_ZONE_APPEND	=3D 13,=0A=
> +	/* reset a zone write pointer */=0A=
> +	REQ_OP_ZONE_RESET	=3D 15,=0A=
> +	/* reset all the zone present on the device */=0A=
> +	REQ_OP_ZONE_RESET_ALL	=3D 17,=0A=
>  =0A=
>  	/* SCSI passthrough using struct scsi_request */=0A=
>  	REQ_OP_SCSI_IN		=3D 32,=0A=
> =0A=
=0A=
I think this is OK. Not sure if it needs to be a separate patch or if it sh=
ould=0A=
be part of the bcache series... Jens ?=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F0D1D6E43
	for <lists+linux-bcache@lfdr.de>; Mon, 18 May 2020 02:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgERAdY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 17 May 2020 20:33:24 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:36927 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgERAdY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 17 May 2020 20:33:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589762002; x=1621298002;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=pD4CdfaP2dTfmbmXJ510uUpJH4xzhd/mdOtuGxMimas=;
  b=KQpO/6L+e/1AdbGgoPpUOGVtz8nETbvROhhjpPhGTRypXPUmgklXZjCn
   xL8gFhP+2zZYr2fnYhBnvyGi+IETMEehOntj4SM5T70loUkOLDuHNLaOQ
   gefVODSqWqVl0yBXhv2dNYLJMiI8tHEyvJyBw8ccFQPS1DgPL+PQfK4Lj
   sJZhJljfynJALhDhKBCWEYUEG0uvEyXBVMpoxqn4l7yeBifV3/4DHSzCO
   4KgJ1D6b4i3XJyXGEntKHrOhxCN95l3kSjzpTaO0p8JUV9QfTFjPsb5g2
   /LfawUaWfIV1xWkzvAF8At9GO78VaviV0YthI8IHcSoaBjN9/xQNpytEo
   w==;
IronPort-SDR: YVeO3o6Pdnr9Z4oxToi+TJ9mtJ/AuSS8gJkGyuCxWAxlddUteE7hJF+AjMf5urCjYnO5xR0Rv7
 rAsltG1eSnN/Tnv+dpMMze39BkfIGjbhwPMiu+SlxXDZoGS2WAaddMwPamPPOjWzEwb/b9KyRN
 n+OAUHJtiLlHo4MPohA8Uh063sQTlrWi64hcx9g46s8hgJaFPUDPBW6wfcQiof8pTD8FRiDOYB
 8cYZXOw4tBPTP11Q2an6MPc98hCl8pwp6kplGQ6npgrS6QImDNDiI6iYapGjv5veTNUHUkhQB4
 VqM=
X-IronPort-AV: E=Sophos;i="5.73,405,1583164800"; 
   d="scan'208";a="246884743"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2020 08:33:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEark2O1wA0DdNzKic71BuvhyU/1J6GG2WpwwXlP9kr89rG83deit/YYh6NOfh9OPdR8pETOw6DWB83OvQRMnRhj/38Ys4m1bvoFaiuSOxKMECYkRRFHzUjQ4QmYP267OKqqX+wVaKHH37WsJQRe9xQf0vpJJnajjkr30YSrKktI8A3U0gfK3y53kBUePwx1SENOho2HGHhGRrDd+sw+K7YpJFLyQbmt10CXI1WSt3qm/RyamcMOD6soAEEY6cFytHg2hs0zvhvFfqWo4hM/TsE1KO4ZPwpbMZI2QFjI1zTa9rac36z2/gf54tiDNWzgwgwTanxrkuPuvDDyCs88cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cfr08Ev8B9Z2gORj2J3v+S/PV7TO92lcTKznTwpUoCU=;
 b=f+HbnDUQ6vn0UuCq91n2SAKk6zOSS99c9jciC21uBucNgTZ0EelqcUULLoqgdjU2Z5TXMH/WGAo+6AnAiVrZjf22JWWo+IUyHlv8zInZ7ccaahCepujUMhBl5LeOEaZuPXEaAk0icF496yqCmSK6g1BG6aic/Aw11YcgokP/yCV7YKW0xe0aV4fDn2oZPSlomnEZBBj/toVHKu+3z1jlb5EUXrZUf18919SYnoHudfVYWtudv+UJ1dwv69OJ1vZjzCRMOMj0Snj6yKUbKdQviKdFHiHQes7hvTpY8M2a8bXAgnWcVtUtmDHND9Q0cPn1EJ8rpZtq6cg4FBz8tpXVEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cfr08Ev8B9Z2gORj2J3v+S/PV7TO92lcTKznTwpUoCU=;
 b=j63UDDDvcOsBEImpC1mrkTwfOWeSoAoxWtWIVmOC6jD0mgEhs+fiLT5ycQOYxa+6jwduFydKSERYMqzf/j6Hba/ndbcCV4yvVgUFZ6KLp4nDQxgJDTECVnx/C+OkMme/QpFD2sQ/0Qq9+aX41KoIROHvcfSV/1KRy6VPqOzPqy0=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB7090.namprd04.prod.outlook.com (2603:10b6:a03:223::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Mon, 18 May
 2020 00:33:21 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606%6]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 00:33:21 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Thread-Topic: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Thread-Index: AQHWKzXNZ12ghqAt20GTR1GjD4GRxw==
Date:   Mon, 18 May 2020 00:33:21 +0000
Message-ID: <BY5PR04MB69005621AE920061F7FD383CE7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-2-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a5aee82c-9ee3-489a-74d1-08d7fac31199
x-ms-traffictypediagnostic: BY5PR04MB7090:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB7090872EE89E5FF870540C42E7B80@BY5PR04MB7090.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04073E895A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ThrmUNuOTGDPBe4CjSjl1KnZispXxNR3lypvu6mLF21QADhHwtm8xJI3THHnh10LuTicq9pv5lQFAoYH0+cn9CulBTH2WZFMpnnv/LlVCxvyY1a0IkvzmNZxQ7LuvfvEB50fNOsWcDR4fTQPLfQAWn1QkK69DVLDQZveK9Sry9p0pHuHIVbAvsJb4uXtUqsd+J89M5VWBWG5zCuY9yykTpbwmI/Av9o8SCzJ8BPqPwGV1SDHdD1I85CfWcN1XVO+fB4KGenXPblBmcIvPC8HisiOhY4fQKDuY/YwNy9yXeChTYrYD1enxe4IkhUcn5lPGCZs+pIiC6sL6347eFvp5iUCqR+r6j/4bksxD8kl3bjOJ1L11Y/qAbT7HX7LoOPP6SCBQ6RVHzpLuqAHJDbP7q7waz5fd7IQzZwTYw2YYuLL05aoIPVPYlRfWUX41s+Y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(54906003)(110136005)(4326008)(186003)(316002)(86362001)(478600001)(5660300002)(66446008)(66556008)(64756008)(66476007)(26005)(76116006)(66946007)(7416002)(9686003)(33656002)(8676002)(8936002)(52536014)(6506007)(7696005)(71200400001)(2906002)(53546011)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: D52PZt+MhBrBwNIjAkGi7AsV4oC3HUz3VdBKNseWWi/QJTXlQ7nUYeyWVkBbCGDcStxVN19Z9IaDC+vLWOEGNzsz88pd1+kLcxlreZmxBT7+/lqsTzRG587dti0pmt65QV/XCMR6HaWaC5fHt5MVPVmxNt/OGy37pAO/8Y0WawQKRBSoc5JNolTjQu7JV9CcPg8XtZGhLX3iWRYBVEsT8AsI4xQ7WPde9fhIcZK77YXF9vFL28wgtsVH3LXWPJjvbBs3rvvYFK6eoXZkwZVg2szYgVxeVNpIF0YuWFZ1i8KJaSw95z/pgq49DR9HYcWYfiYPVZ78EiFqx2viEcfxNKqV4Ai/QjLeEO3sC8PAWH7SPiFDEdGBuVYfNl3Yt0iA31aOgjSaX6QivsX3t1Tqlc03+xGiMDGMIGUE9yOuD0vFbzDdBGv0FkFnMf2PcuJ32CgguRJY7du3Ul89Y5pucC57kqXIgp//CRDaHuR/m+fZBUBX15wgZj3qOaTua2uo
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5aee82c-9ee3-489a-74d1-08d7fac31199
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2020 00:33:21.5567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghJTjAI18ifrpMRNQsITNt2dFSJqu8B4PndEWxUB1NZvPLexHcXH2EL6uv3s8SL1EH+ShKY6eEhq3T9H3WO5rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7090
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/05/16 12:55, Coly Li wrote:=0A=
> For a zoned device, e.g. host managed SMR hard drive, REQ_OP_ZONE_RESET=
=0A=
> is to reset the LBA of a zone's write pointer back to the start LBA of=0A=
> this zone. After the write point is reset, all previously stored data=0A=
> in this zone is invalid and unaccessible anymore. Therefore, this op=0A=
> code changes on disk data, belongs to a WRITE request op code.=0A=
> =0A=
> Current REQ_OP_ZONE_RESET is defined as number 6, but the convention of=
=0A=
> the op code is, READ requests are even numbers, and WRITE requests are=0A=
> odd numbers. See how op_is_write defined,=0A=
> =0A=
> 397 static inline bool op_is_write(unsigned int op)=0A=
> 398 {=0A=
> 399         return (op & 1);=0A=
> 400 }=0A=
> =0A=
> When create bcache device on top of the zoned SMR drive, bcache driver=0A=
> has to handle the REQ_OP_ZONE_RESET bio by invalidate all cached data=0A=
> belongs to the LBA range of the restting zone. A wrong op code value=0A=
> will make the this zone management bio goes into bcache' read requests=0A=
> code path and causes undefined result.=0A=
> =0A=
> This patch changes REQ_OP_ZONE_RESET value from 6 to 13, the new odd=0A=
> number will make bcache driver handle this zone management bio properly=
=0A=
> in write requests code path.=0A=
> =0A=
> Fixes: 87374179c535 ("block: add a proper block layer data direction enco=
ding")=0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Christoph Hellwig <hch@lst.de>=0A=
> Cc: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.de>=0A=
> Cc: Jens Axboe <axboe@fb.com>=0A=
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> Cc: Keith Busch <kbusch@kernel.org>=0A=
> Cc: Shaun Tancheff <shaun.tancheff@seagate.com>=0A=
> ---=0A=
>  include/linux/blk_types.h | 4 ++--=0A=
>  1 file changed, 2 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h=0A=
> index 31eb92876be7..8f7bc15a6de3 100644=0A=
> --- a/include/linux/blk_types.h=0A=
> +++ b/include/linux/blk_types.h=0A=
> @@ -282,8 +282,6 @@ enum req_opf {=0A=
>  	REQ_OP_DISCARD		=3D 3,=0A=
>  	/* securely erase sectors */=0A=
>  	REQ_OP_SECURE_ERASE	=3D 5,=0A=
> -	/* reset a zone write pointer */=0A=
> -	REQ_OP_ZONE_RESET	=3D 6,=0A=
>  	/* write the same sector many times */=0A=
>  	REQ_OP_WRITE_SAME	=3D 7,=0A=
>  	/* reset all the zone present on the device */=0A=
> @@ -296,6 +294,8 @@ enum req_opf {=0A=
>  	REQ_OP_ZONE_CLOSE	=3D 11,=0A=
>  	/* Transition a zone to full */=0A=
>  	REQ_OP_ZONE_FINISH	=3D 12,=0A=
> +	/* reset a zone write pointer */=0A=
> +	REQ_OP_ZONE_RESET	=3D 13,=0A=
=0A=
As Chaitanya pointed out, this is already used. Please rebase on Jens=0A=
block/for-5.8/block branch.=0A=
=0A=
I do not see any problem with this change, but as Christoph commented, sinc=
e=0A=
zone reset does not transfer any data, I do not really see the necessity fo=
r=0A=
this. Zone reset is indeed data-destructive, but it is not a "write" comman=
d.=0A=
But following DISCARD and having the op number as an odd number is OK I thi=
nk.=0A=
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

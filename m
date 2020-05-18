Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EEC1D6E49
	for <lists+linux-bcache@lfdr.de>; Mon, 18 May 2020 02:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgERAkC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 17 May 2020 20:40:02 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:3297 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgERAkC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 17 May 2020 20:40:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589762401; x=1621298401;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=5ymd8aeO88j+6HFp398nll0rdU+weVCFAjVF5RzXip0=;
  b=JTkFWNa22Ez489P92gkhXhlvJrqtk3xl2MUTgLMFZ4X8Flf4gXK/Bw87
   5iGPBT4g0PZTmxCQsinD3zSCWe5bUfQ13KI2D0thXUFTNVnYwPWKphKUH
   pOqfMAXzbYHOBt5oojiAffkHCIlXU+joycK0L9d3HknWocY42hJZ8pWTl
   4fdNMyhu70B+Bd7PU/elzQhdJ9ibyRFiTK5+jDeK40qy9PFDx6QcuRnvr
   qGV75DuPrOPvtzib21CsQVgCauC84m7nwE1h8PdlglezTyScBpMMrooCL
   x6Gn/l+dDAq2/ouIlosC1sULsoSIhzfDPZPlGwRb5JcyZSo+Ic3wvbExL
   w==;
IronPort-SDR: uIS42MHEvYvsNkgzG1ecMQdMsbJrHNE0YTiDYOuMNtjnkiPH4KCmwxF/FvaJKfUeBO2l/ef7Zg
 t3qgASYn6W3eXCLVGJjp65WQkdBK444L4GxaV4wSB0rUsMyRB7bhS+b8WeshG/F3G34MASXVkB
 xvTxh/5ZHCmDHsiLziZWC1hrOmx/upQLHCUKW/e2Es6JWFMzGfFVN8IOVCzoz8nLdmpQk3YaN/
 tDbjtt89/0g1hY1nZ4nTyN8u1JUV8oz3f6xfm0RNFC9H9HG4P5taNbtfW6IKaeXrQwTRIlMhcb
 53Q=
X-IronPort-AV: E=Sophos;i="5.73,405,1583164800"; 
   d="scan'208";a="138235422"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2020 08:40:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZkiftdV7D62x/uk89FoKOnkUFECuj/WtXKOQL4vtHElVGWqWQin9BJ0fMU5SzfOl09nepFsLKDv4YnU7zcSlUUJYvpb5Vx2Tf2C6wz2q86fzOD4PvGpgr9M/sIl78subBnLpE7xyAIY4GhyoH90JvXIqai1K7rjAxdEub/5Alg3H7XR6kF3gdQMNsUCObOhOvf5dAhOLouH2XggdWnbdL7Jam7+/vD9HRwM82gn28/8jgx5INn4e4SfuB1XqQHyRMCcjtWXd/qybjKK5DSsQt4BA539PTNWcx64w38jseH6I6csE3/ZrnoFzqrZIfkdIB+TwW4yhH0JvSZHHPIHdVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnBQ7j+/h3JBoe1TJM7F2QPmZcImzUOWf2Y+fMaqzv0=;
 b=odn9kEzXOSjPIpbLiumUwPAoVNgNm81BDVfsi+L6m9UgpCT1ZlivQZrM/AseKpcq9J/A93TusyPyPXnZSQTQQy0gFGbgghCXBbQtd+XtvX0JoZP544opBtI3KYDBhzdoQd/Eb1+19Y7pgvt4/LZ68PXuIK2bIIF9QPzoa55Sn3O4n9QG6BPDN0AxWuUVLLntTcnj+M69+rPbf5hfxNkfloMfXX6EpD3q9TLt/Ga7Kt73iRGVkro5e+oqgMT3dTXN3FTpdBhc/iQ6sdgP9fwbmmmBlw7pWEIMOjrilJXOy4bEpPclIUonImWkaRva26kMIcE1/5VsawvULGyfUXzT5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnBQ7j+/h3JBoe1TJM7F2QPmZcImzUOWf2Y+fMaqzv0=;
 b=tKPw42+AZmRE+c9iYdqWdQoJoONheLWl7jxE9egir/WiRpkwEJeZk8pUNC9KyBw6PY5RIJ/f/yDO5S9grzvT6sANWzD9IQlDba61gBBpAeOy3hUzU3RVWWER8s/OYsLcQYDpOwfxGBcXVbuFsXGjJAfPdwQmwz7rzQyF9sDGyJ8=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB7121.namprd04.prod.outlook.com (2603:10b6:a03:223::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Mon, 18 May
 2020 00:39:57 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606%6]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 00:39:57 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>
Subject: Re: [RFC PATCH v2 3/4] block: remove queue_is_mq restriction from
 blk_revalidate_disk_zones()
Thread-Topic: [RFC PATCH v2 3/4] block: remove queue_is_mq restriction from
 blk_revalidate_disk_zones()
Thread-Index: AQHWKzXQPn7ylq1QrUmRrc4/xaJzyQ==
Date:   Mon, 18 May 2020 00:39:57 +0000
Message-ID: <BY5PR04MB69002D8AB1B63F428D28428FE7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-4-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 84bac8ef-0f42-466d-eb58-08d7fac3fd65
x-ms-traffictypediagnostic: BY5PR04MB7121:
x-microsoft-antispam-prvs: <BY5PR04MB712117293A2787D018253208E7B80@BY5PR04MB7121.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04073E895A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zxdwxI3tniXmVpaVn2pPy9Fe+jTjBjGjmjxwYwRiNpptMjVPQCneh6bZg7pmBLBSKM6sN9/tOvfCs83NMIPnR9tnnVLdFocVWl7GfoJDH8O4u5U/6Sz0wDeCrKLzRD/EsJqAMjQvDsCxLR18mdXqRqREQZPj38NjZvED7hJGaB1sYDlcDk3Jzd/GrVs4GVcOb6353LpMVNHSfkW0BkLvITaT+RPd5ghvAdctMrd5dM0OI1JMdO5pL399imOysfq7M1yFzTxYTiQPJ3D24G+njWEOeUEIKsM8g4a8V5TWtgz1GRI+ZBujiVE5llNCKYiJOsJ8aDQA6GfyxmQLSa365U05EthJqwJE2RDWYN+kxNgUO5vrjg4jeZwh/esBFB4jNdGRPyekP3DXc9Go4V2J0B3IQFh1hYk4FUra/vkuj3gLOYkqlowyhc0PT3W+S0NE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(52536014)(110136005)(54906003)(2906002)(316002)(8676002)(7696005)(66446008)(478600001)(76116006)(66476007)(66556008)(66946007)(64756008)(8936002)(53546011)(86362001)(6506007)(55016002)(186003)(9686003)(5660300002)(26005)(33656002)(4326008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: sYsgV2/lpYYZzRM5bgNtRVXJ4Os5vzmkV7c3rIRdttnV2y+PuJ0uxDDTCAlDAAylyaIUisiwgsucJQOsza7FcXXnRJpjijeOcBGAmTrn05VVsD51im84gmYVSJftMBLrzuR8jkFprEBzuYZ0lAJSVboo/ba1ElgLybOGkbtUlmDxBAB49WWuwc/JGx7U2miAwc++haD5jxyVBJPcfrVN2/1ZEMApcJGOsM7JAoPIS1uk2qyS6++Ztx45m1dMKcwFmf8TGbzj+AFZ/Wa39Sf+VGNCspUk0bBhZRs2aaR1nT7k058V8pqm+BFfQMA5vJJBBhoxEm7K6dK3fxossW4AoXRlneOwUBO9GVj6rHrC4M0Tlf25INq5GMqmZWQl+p6TZly/iaibP6Jvn3+3hxDeOm5kkqx2T1UHkWU43CgZFq+ePFiiPWPAmILgSmtWttYyS6rliUzW3VcLCAA4dwZbRGCSkPMX0zAYRYOoaKz94nVviZvus78nPkvAdLbLOfBb
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84bac8ef-0f42-466d-eb58-08d7fac3fd65
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2020 00:39:57.0816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8OQcPHM9N78lZ1nTgvRsvDz7XxgXwmPOSTHybFg6glM51/LJVbbv8pdzgjYReGR31dPXB0IdxzK2FgQPkMBXWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7121
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/05/16 12:55, Coly Li wrote:=0A=
> The bcache driver is bio based and NOT request based multiqueued driver,=
=0A=
> if a zoned SMR hard drive is used as backing device of a bcache device,=
=0A=
> calling blk_revalidate_disk_zones() for the bcache device will fail due=
=0A=
> to the following check in blk_revalidate_disk_zones(),=0A=
> 478       if (WARN_ON_ONCE(!queue_is_mq(q)))=0A=
> 479             return -EIO;=0A=
> =0A=
> Now bcache is able to export the zoned information from the underlying=0A=
> zoned SMR drives and format zonefs on top of a bcache device, the=0A=
> resitriction that a zoned device should be multiqueued is unnecessary=0A=
> for now.=0A=
> =0A=
> Although in commit ae58954d8734c ("block: don't handle bio based drivers=
=0A=
> in blk_revalidate_disk_zones") it is said that bio based drivers should=
=0A=
> not call blk_revalidate_disk_zones() and just manually update their own=
=0A=
> q->nr_zones, but this is inaccurate. The bio based drivers also need to=
=0A=
> set their zone size and initialize bitmaps for cnv and seq zones, it is=
=0A=
> necessary to call blk_revalidate_disk_zones() for bio based drivers.=0A=
> =0A=
> This patch removes the above queue_is_mq() restriction to permit=0A=
> bcache driver calls blk_revalidate_disk_zones() for bcache device zoned=
=0A=
> information initialization.=0A=
> =0A=
> Fixes: ae58954d8734c ("block: don't handle bio based drivers in blk_reval=
idate_disk_zones")=0A=
> Signed-off-by: Coly Li <colyli@suse.de>=0A=
> Cc: Christoph Hellwig <hch@lst.de>=0A=
> Cc: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Cc: Hannes Reinecke <hare@suse.com>=0A=
> Cc: Jens Axboe <axboe@kernel.dk>=0A=
> Cc: Keith Busch <kbusch@kernel.org>=0A=
> ---=0A=
>  block/blk-zoned.c | 2 --=0A=
>  1 file changed, 2 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c=0A=
> index f87956e0dcaf..1e0708c68267 100644=0A=
> --- a/block/blk-zoned.c=0A=
> +++ b/block/blk-zoned.c=0A=
> @@ -475,8 +475,6 @@ int blk_revalidate_disk_zones(struct gendisk *disk)=
=0A=
>  =0A=
>  	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))=0A=
>  		return -EIO;=0A=
> -	if (WARN_ON_ONCE(!queue_is_mq(q)))=0A=
> -		return -EIO;=0A=
=0A=
Same comment as Christoph: BIO drivers can set nr_zones and chunk_sectors=
=0A=
themselves, manually. They also do not need the bitmaps as BIO devices do n=
ot=0A=
have an elevator, and as Christoph said, can (if needed) look at the bitmap=
s of=0A=
the underlying device (e.g. for zone conv vs seq zone type differentiation)=
.=0A=
=0A=
So I do not think this patch is needed, and would only cause more memory=0A=
consumption for no good reason that I can see.=0A=
=0A=
>  =0A=
>  	/*=0A=
>  	 * Ensure that all memory allocations in this context are done as if=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

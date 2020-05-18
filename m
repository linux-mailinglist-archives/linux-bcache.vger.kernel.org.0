Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D478E1D7023
	for <lists+linux-bcache@lfdr.de>; Mon, 18 May 2020 07:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgERFJ2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 May 2020 01:09:28 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:10617 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgERFJ1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 May 2020 01:09:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589778567; x=1621314567;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=jniKQ7KenpPaVIeWxR/nKeX6MjkX1glXIyhjq8SKq64=;
  b=lqqAhFfR24IvXYoGD0FN6CeEZJemykbHu2K4tpkhZkJg8hObYlVAUrPW
   yY3sejXOWb4s5Y6GKRkXZOtdjUIxkxS4ESMNvlxJweXSY+OKxx2Nb8OY4
   dcCKpgW6G8rK4OEtn52O6unUocev47CPGcsi4oC9lPxq2+J5oxDKXdvhl
   gJpqkMsPPmq+k8Gc6i3LsZdIr649qn680q+oQ9uRERAbu0i6mpMghRmxg
   VxGLVWGBJ+02qpXQi7ukcuuijWMerBAxR60pNDbJfl8yNnxp64sU4JUCv
   OX+6TI3ONxRxvlWdJloKLH0kIqmYSXOXgWKtAssKAQ3IRNOLm/s4j3k0d
   Q==;
IronPort-SDR: yfbcf31rCBtUzj7GGbxnmtzsIH/otDigbUypAtrtanmXOBhP2Cl33f8XkFkT2g936ydD8F3zXg
 VOXtFfCHcIzEmtlGtXk6QSlJKPTQYwucrgS3/dh5wcil5VK7gQQUpyCtdOb0TlVRBLYDXNFQYv
 3ohvLRUbsjQdIO7MEUJaffzUWoTFICnF04tNvG147MgIFAvFknoAegLpeJ3aULQWQsSCw1xME7
 5y2nXCBPpcXyOuLQuMVrgriaLqzj+yR2Om3+ulms++CgJVJj/+sOK5LE6pIeU3pIXGqevUMsR0
 LL4=
X-IronPort-AV: E=Sophos;i="5.73,406,1583164800"; 
   d="scan'208";a="138249946"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2020 13:09:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGa0Vv+xtN1FGSYD4fMySfBKUJJGk6FOp1nkTGsAWCN6ZYNgXv4ia1slCFAufwltNmng+sH2tM/RgU88GnbXMcO5kmy3zRrpTd9qciG0QXCRtHcPh6PjPBHwJ+6NJeLWMRQYA2jdrO/97ZjB9DkWm5C7FWLjpj4gP8NCXUJvJN2E7zU4BTADElMfcO6EqpSLcWRfbGrajGw+TYGkIILN/ViqtawY2ae+iD0PFrnixcnK44pn4iXRfM+ZthQmQ2/zE2YFJ0o/QvRPcBXUYpVPtO6aokLVKSCcrZd04j89+bQAOrPZpGsDEBzDRZRNQ/vUY3UFAzkZ2XUohbHVEHQTvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jniKQ7KenpPaVIeWxR/nKeX6MjkX1glXIyhjq8SKq64=;
 b=RhZhFi5QDFp4jtcQBDeZ3bCqTBxTrRXLOWqKpNYsMZjWbu/8uSNvN+AcHZBuSeDnpPh6mm6p2Cr5iEztU/VyIwgm7gLvproBdnpBlC3QTu7SCcQ/gAQ1s06nNJ6lDuA8RvkYJir37sK9GgGgEGTrV8oLhpH24Nq1X4wJj8JjKbRiH5b5i3+iPY7gVz4DETufr3fau9gD5GJcUjWGYPnuyDUiy3Ql5IOuafOMlK9FoL0/m0w7YBCs/wr6M0y8VXxCZQ7jlWCl2Q3UthcAcasFVRGc/vh7KcJVVUWhJmFHLOxHvs5OPMKlkxH42DJ45jXBdlfszLfpfyA4Ko7ztrif/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jniKQ7KenpPaVIeWxR/nKeX6MjkX1glXIyhjq8SKq64=;
 b=wTxbp9UcLD6blaUzAbuZ3GzAwGtIQroyzI/D/Vy+Ry9dkK8V623luDqNKKBnLNK/odlJebdl6Mx5dDhqqG4CjqOH/iuaXFrpa03WFf5ziXNbxDtl+mudLbBiQGSWiDgwEJSkTaweKqZz7A0RX3qiMQaX/7CoaDxbFjj+vZup2yw=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB4549.namprd04.prod.outlook.com (2603:10b6:a03:5e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Mon, 18 May
 2020 05:09:23 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::4d72:27c:c075:c5e6%7]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 05:09:23 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>, Coly Li <colyli@suse.de>,
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
Thread-Index: AQHWKzXNx0htYVAnNEmE+sJXY3ZbhA==
Date:   Mon, 18 May 2020 05:09:23 +0000
Message-ID: <BYAPR04MB4965F50C13415E486F519DC986B80@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-2-colyli@suse.de>
 <BY5PR04MB69005621AE920061F7FD383CE7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aa6ae7c5-30df-4dfc-90c3-08d7fae9a11e
x-ms-traffictypediagnostic: BYAPR04MB4549:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB45499AC5AC21F0EBD44F140B86B80@BYAPR04MB4549.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 04073E895A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ij8NsrbIpegiuBm0b/1vORHnewLWFzUM6TOnvx5JP5IVlqZ+nxIzv1VsUIWXhmzCDo0eI7yXwi1RPGiprSimpHHSC1JGXEfku+SS5EL4BbmXd+MHCVZbp4IALZdPzR6LcKzZ0R2g+E/zd0BWq3ep2YWi8kvuFm689VVFP0LEkcnQoTxLStG7aXd+JGv4EGr0naO6tUN0llhB4sX7+U/37B1JVQf6ng+zAwSM5qqcWv44JizYw9N+qXhzfQpAS+uo2IkiKcRneFVddlB+hy7UzyA1Cmdd7xrgLzxyjB92yi1kjneh0bDLYPrtMWpXeeR//hEAdOJAJxd5IDrG97AyyJ2DsCMV11xycdQzxtzrqjRvj5Ev0BwmCe9xoEjZBwLYVsjY6GDMLmBf/m8cOQBqCTC7d5Fh9waNqDQJ6q20whNqyida3Csi0LLNEbSjmVrM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(4744005)(110136005)(7696005)(478600001)(53546011)(6506007)(316002)(4326008)(26005)(33656002)(54906003)(7416002)(52536014)(186003)(2906002)(5660300002)(8936002)(71200400001)(8676002)(66446008)(55016002)(9686003)(66946007)(86362001)(76116006)(66476007)(66556008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: UIACVAM5V4WM/WZvVJSze/YVxb/fCyoYe65eOwZcLcmTCfMw+5x8tYE71CK/NKlfkglXXSBiKf/vol4C3pFIQuvOyjyelmnmhoYxeCKHIAlX3oMRdqX///dmXzy+/wjVaC5sBonFWREfdRiAfG/xpx+GukXqumrsfWFwJZoiCYFVEdS5kpVhhknB4giMdZe2B/Bscjbuj0y7kpzSz/d6/AcU2Z4fHIKxFI8X4aoDzwj69yNfozWgvWbbd9HXn1SgA/modQRo1WqgDT6F+YHCtSADXalcTd1RwZpoxmeB9oBxIxMyv+qnQNm3Xmug9nr3LvKzP2cclN++VTMJhuHNTICz/W+1Shhw3/cYlYhTTRLV6HOG2ILoD720192wTpC7T6pDPqYksdLZ5mLmDj0r16KTws12PzqZXPoTgxbAk6hh89zRV1MdZ2FZyUWoa/FQ45bkooVqjUM/8MWrMvY8Ey8qaO1mYQ9254JftI9k6NA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa6ae7c5-30df-4dfc-90c3-08d7fae9a11e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2020 05:09:23.2074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4PQSe6saTyFbYJ4gK/l+/MfiETBM+H3yrH9HK4yl+oyA15RAWqMG5k6cQ6fTb8XUy6971ZE6ASnNPHjsLFTveWxEzcVbO1tywUMLSiSjNBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4549
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/17/20 5:33 PM, Damien Le Moal wrote:=0A=
> As Chaitanya pointed out, this is already used. Please rebase on Jens=0A=
> block/for-5.8/block branch.=0A=
> =0A=
> I do not see any problem with this change, but as Christoph commented, si=
nce=0A=
> zone reset does not transfer any data, I do not really see the necessity =
for=0A=
> this. Zone reset is indeed data-destructive, but it is not a "write" comm=
and.=0A=
> But following DISCARD and having the op number as an odd number is OK I t=
hink.=0A=
Let's keep reset consistent with discard and write-zeroes.=0A=

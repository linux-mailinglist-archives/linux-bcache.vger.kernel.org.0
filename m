Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D601954E4
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Mar 2020 11:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgC0KLK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Mar 2020 06:11:10 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:59020 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgC0KLK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Mar 2020 06:11:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585303870; x=1616839870;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=HMeqeuSXCIfAZD4a4YdLs0zUrrSWrAYG0y/WkG5zG10=;
  b=Uv09fyM/WWiuZhtdYGKpUs2D5/j92wqk65ssKgNYPpxCHb/s9To/6lgs
   R2uL7f+obQVxHaXKiBrV12s+Gy86kPsfGSAUjnFq6ENePYHDhtS/b4BwF
   aeB9kVIPcW2r2lL+9ZiYc2PbC9pJZs1ZSa7Xvw1b6iF86FTuF4Xg+oWsE
   BPGRetwR9Zh8tfMWldbY9/kYr7w4zaScI2A8mLp3btu1aC1kG4Ns3S714
   0km0uKPzGinJ1XtAx4WpjYxrufWI1zIXxFvV397SP0m0uF7wbVg6v5aVM
   GpIl2UCIIgNn/E36O+r4ojxgCTudHvrbXpFveARU7y6KGc7dj2w7dmvqB
   w==;
IronPort-SDR: vmEoBOWpB7yzLwj+uDQSuPgNKKvq0WJ766K5HyBWTGGQF4b5N2/4g24D33lEtrhazWtD2GVzX7
 1ObzC23HqmDaGcPj6ASafxRr6c5LcidWfl2u9pVI8WNfeq8hyu1xpmlWA3jTTj5AtyZoq6/CF1
 D1SXL92XR7p1SBYeqtBE7wyyaUgr9vBngKQe5gF11UzeI7DV5kzmtCCVwM+UociiLKtJzNH94f
 SYNpSmPHn/cM/LMd4eHlRewUtyAFnEElXLvJBvY2fSCkTuzWLBRfDDMoQrJv7ZN0i9g4fY2puB
 jVM=
X-IronPort-AV: E=Sophos;i="5.72,311,1580745600"; 
   d="scan'208";a="134103365"
Received: from mail-dm6nam11lp2175.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.175])
  by ob1.hgst.iphmx.com with ESMTP; 27 Mar 2020 18:11:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGZhiI7YADeRcdGYeZT7jdD84f4J3ME/WqamLPCT4QTfMykxvvwqhV8aqN2C27teE1XOcifLZeDiZzCXK2ANB2DCK6iOrDDTeDkrPBTFbtCtLi1NpZGV9KF1F1p9kGQsSTkBuItJhBj7zf1tm8Dn/FSXuAX9cncXj+MRn6NRbE+TbFhthS3PZ+iYxkYni7Kh5isQUSsP+lRzNwvpIjpVlRCVm6UGtYGIvp+sWUIxkVZQYq+2BIFqFp4ERtBcYXQWenOlcayD2t7fq2qa2hcDquB3P4WGZqf20C8PlTi1H/iF6HoTVVU7/4iRAN/FVnSMpO1NLSEIHj5adJc8UYc/tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGc2isNrsOI4XDJ5ksCgdA8GkbKRLQU7CyZdCRGtTN4=;
 b=FnXUUMdO2V+zK5Sce9pcOJ2HQO0KxVtvozpnj7sYIiT+qtrA0Xld4EeN8LMCmgslpiFGPzsKnYV258s70rI6jeVCMr7GzilmN1pYl7hn3Ze8DeaDmVgu+jg4E+h7I32cRq0WPCxQUAXH2bykoSiJRQWEgWkdY392uencolFoVgGlM1choy2DaIBsT97m7OB4ZHVXmUfZjxQSn55YBCcJx7+Fkqkh/somwbnn/5aHztaXTCxsxOErpMv9vpbHJ8mnfezAtuU63rA6Hq5bks8sxZelYKU/g3i8u6jJtRFYoUueHgtpOH3kj3pniQcrPvBB3o9UYdwblxS3qpBjFUK2Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGc2isNrsOI4XDJ5ksCgdA8GkbKRLQU7CyZdCRGtTN4=;
 b=e8rDR/GmHgeyZlSfZ4M9K/Lspr+e67pQmxJ82WMpzm3fZNv21JNCL1v8UVsWGWdWyF1hsFcysDDBYsWeuQ+JUjVgpApcddEiUClpyLtIFo4iGIRtsPovWQw34sNPzZ2rgCSlbiCVsG1dGd7XQ+8AowWHSR2I4qq7sZoL6Tu2F7A=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3678.namprd04.prod.outlook.com
 (2603:10b6:803:47::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Fri, 27 Mar
 2020 10:11:08 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655%4]) with mapi id 15.20.2856.019; Fri, 27 Mar 2020
 10:11:08 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 4/5] block: simplify queue allocation
Thread-Topic: [PATCH 4/5] block: simplify queue allocation
Thread-Index: AQHWBBJBOBNuCF+JvkmkSk5kjyZuGQ==
Date:   Fri, 27 Mar 2020 10:11:08 +0000
Message-ID: <SN4PR0401MB3598BF20E4DCF8F1B129625E9BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200327083012.1618778-1-hch@lst.de>
 <20200327083012.1618778-5-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Johannes.Thumshirn@wdc.com; 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7dce1062-9bba-491f-ee6f-08d7d2372af9
x-ms-traffictypediagnostic: SN4PR0401MB3678:
x-microsoft-antispam-prvs: <SN4PR0401MB3678DD2D871196882E9BB9A29BCC0@SN4PR0401MB3678.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(110136005)(7696005)(81166006)(81156014)(4744005)(186003)(316002)(26005)(33656002)(91956017)(478600001)(9686003)(2906002)(55016002)(52536014)(4326008)(86362001)(66476007)(66446008)(71200400001)(54906003)(64756008)(66556008)(5660300002)(76116006)(66946007)(53546011)(8676002)(6506007)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iyZ83M8GYaE9FugbunfSGGuqt6n3HEHBcWLoob7rHy5K/IiiskpSKYcNg0MgRI5Lge72rwd4AuBEFPdvKTmJKbM2JcfZ7l/YsthNbNEjBR8aWUVkUlynFkNknP4P+dWNvdDEUVpcud/9kqZSQZcr0hoCJJV6ur4Fk3egX0TaPCKvhB+JihA7AKA18yk+/RYBTI47dRHKxH2QEFmRIwSyrxXE9bwVe5hjJM8KqUC3md+E1TmYS41vTqKOKuEijT0EPMr4c2zARfnkBsG4IEMmYO49VQ2G3EvHvd5A7MTeiY4Co6ykYPb8hvRr3Vg3sCopaVwTObjLk6XWT4kbRy7waJobocZ5lEBVtQNBW3lwPkrDpJG4WZYvZT782IbqEqvctyU50yDo3jPe0nFJNUQRZydkaxjzomDoeyQlPbBg78pRNU4fyAJ+XtCGLhib9sK4
x-ms-exchange-antispam-messagedata: 3hTlO/oVWyy7sKLTx9fVCMk8lQIufgXvqY8PDQ3JowMY4cvPXIZIz7iorenkNPiShCkKr0iVTCt0UdYwbSHsBrRbNh6IN9B8NV4DtnwvAj/FnJwsFcCNupgU60AKc/0cMq5GZ3PhHu/VPSXreiR+Hg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dce1062-9bba-491f-ee6f-08d7d2372af9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 10:11:08.1291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HBramJVOGaQ05a8+z1IZEDpI8TjYgsFAN+FyoLw8UBjxPCLgIogvfEYmjrjYRMGHaPOzkmgQ1p5q5vSHIp3xv7tI2Na8LdPl5pDKIk8dYG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3678
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 27/03/2020 09:34, Christoph Hellwig wrote:=0A=
> -struct request_queue *blk_alloc_queue(gfp_t gfp_mask)=0A=
> -{=0A=
> -	return blk_alloc_queue_node(gfp_mask, NUMA_NO_NODE);=0A=
> -}=0A=
> -EXPORT_SYMBOL(blk_alloc_queue);=0A=
=0A=
Why are you removing the non _node() variant? The memory allocation =0A=
function for instance have this indirection as well and I don't think it =
=0A=
simplifies a lot passing NUMA_NO_NODE in each block driver.=0A=

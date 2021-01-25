Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9E930322A
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Jan 2021 03:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbhAYORn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 Jan 2021 09:17:43 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:28212 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729186AbhAYORd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 Jan 2021 09:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611584253; x=1643120253;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=plqN6ULfZWOnYxzWZjh5wDrZvU6JIiXe5tNC7vjgfGWJgo7N6JXokkPV
   V8VeVPMXqK9zrmg2l/+NlGsdOL5ANKj143JNCeXLJyls0hgZKzkKqboiJ
   1PVmNVtpTV0VM5dZon5UgFmKGzWh2gp4cPF7k/Lb+MhuwBc5qPOY3wELN
   3olQx0pLTOU7pnGMweXNWQ/dcZml2s8C02uIgFToGYeaXuYEyI02zreh0
   NcqplF4qpZAorRDuK8HpAj97U7z8Ze40bO0OP3VYaP5QCeOxCYi0/uwN7
   lOOMajRnuJ/0dMhRosPJMkqBdCLCHku13EhFo+/sE7/jcKFqLhxlJn/nz
   A==;
IronPort-SDR: qTagf3ki+EPA/XAMm7uptzJnwMYd+FUpsoAUPAXs2F5/7oAFJMPCspjzJygQU86vKC2ccoGWuF
 Kh4S0i8WG3GQ5l6hOkJT1og4TGqGI04ektdvdIDO16ww5lpXrtAwgZPD47DpNMS2eWswyhk//x
 gjVYby7OeRUokKDO61m8cIzVxlll39W3LMFcvCRl5/wmDf+hY3vYE9bJqp3uk2o7efDjOm0sVp
 5Sj+v6UljCw5GESobRnMrhJa5u1ff5MnUiWTpRr5Vwpu/1UxH/0cebkSB14088mRAY7JC4tORm
 d/c=
X-IronPort-AV: E=Sophos;i="5.79,373,1602518400"; 
   d="scan'208";a="162701801"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2021 22:14:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIKzWtm70kuelpOWyzrrIYam3rDPkakiCbEjR3G1tKr0FNvXEw68YWbkWCKoF53qgy8HTuCLHnbb632MWD2CJEwKIsEhXAdiCI6k48rPNbw8MEzWQi6cHGNsgnmoSIHX5sKax9HKbrVZorArps+3vbm35rdVeeTHy09apPNyWvWtKHF6T4OfZ6DDsdCfuYDUgo603OKUq7SUGoVkly9QV/DFgmWAjCo6exXhvAKPuC2yWraDk61iiGn1X+MCgWEtHDs15XznTgR6Ft5Pc5uUb5ErkBteJ11A3+YMchavdScjf8PjAwt9mZsi+Z6xfHY3KANNlLFhqmDW53AJFfdcxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=dK6Y9YB1ploSPo5LS1a1ghI/9Q/hA3+0bMiCWReYk60nRgzwSj/4OZ1jAhW7QUbgG21ODZSu3UXuziqSmURXjMvg1TymDa0XYb+v1Gsg3cm659Znnr9eNj/CMXMzJ82h3Pqpi0VQ1IMmtF5AXUA+wa4CPSuQY7wLnQEWpf2NWpON4ReXuOjD6/amG/37xgPxsH9rmDip45NoJcxvbshgkF0w3JO6CAW/IcMQ5UHgrJ36MXrb7y7U+z8q8CVetM4ZZxC8uSI2D8t1C8VMF7pp/o6fhNeHh9Drq7G8fWKOXBJ9iCRsSvQkyej9UN+OArUGbgeB7zP1q70ecZ9tMZZU0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=QM0m5iUjH1JwYfWdKn9+yOS2OyYhA7XPUkY/dbBEEmRF3e24CnN+5cNUlwUefNyZohDwVjbPWgBx2wxmseDWl06M2ExmYKDdoICViNGvzV6mLCAfVf5272hLbhy7FcfuVcEhIYxviELAfk9v7BT2IuHKARlxvSy+ek1ioC3iAwI=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4319.namprd04.prod.outlook.com
 (2603:10b6:805:31::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Mon, 25 Jan
 2021 14:14:06 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%6]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 14:14:06 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 08/10] block: add a disk_uevent helper
Thread-Topic: [PATCH 08/10] block: add a disk_uevent helper
Thread-Index: AQHW8jkXIqNElehhEEiDCcJeiMg69A==
Date:   Mon, 25 Jan 2021 14:14:06 +0000
Message-ID: <SN4PR0401MB35987817DFEC3A6344C34E0D9BBD9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210124100241.1167849-1-hch@lst.de>
 <20210124100241.1167849-9-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 485e63bb-7c3f-4581-5bc0-08d8c13b7a01
x-ms-traffictypediagnostic: SN6PR04MB4319:
x-microsoft-antispam-prvs: <SN6PR04MB4319C6923F6CBB53E34518EF9BBD9@SN6PR04MB4319.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bCk6Jb8+QfXyraTfaRPSO0Z4tOap/NHbwVyo7Ed7Jsgx8xTRxqHvWq7y6zJP8fEExTQYQKRUQK1ld+pb0WwwG+gjCh4sQDsJz5WjOlXIu+p+nVDv3oMS+KadBoXNvZqdA5Ee6A0cfNHjItEy0zpotJIZr57k9/2tt8qnt/jfXlLHdwZ1ctQ1EAklQi8u2K+zEyOTDWBmOzjq1JzJFbMrXW5gO+F2oYQ5PUI7ePcGsF4SIKo4aecLTz1ixW+J3i9zfpB0bjlH/0sbJB3/JeGb/AlyxErjif/dXCn6S2hZacoDE0EF5hwO+a9ZzejOMdbHNKxTzeEWaXO8QmMxHeQObU2LW9MXjS55Upr63mcztFFZYvy3B6RgflkbTTA1vv6OeMj3EIKKtEceP7Dw831l4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(4270600006)(71200400001)(54906003)(8676002)(110136005)(8936002)(316002)(33656002)(7696005)(5660300002)(2906002)(66946007)(91956017)(76116006)(86362001)(64756008)(66446008)(558084003)(66556008)(4326008)(66476007)(7416002)(52536014)(186003)(9686003)(19618925003)(26005)(55016002)(478600001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?DY4V+TmXM55i/Akra5XOIzLfrUZf+oUb1MrkLQUi8EmFMZfVUQJ95xWLANBG?=
 =?us-ascii?Q?+KsioA+tJf1dA6Ee+9jFMVVIsUVA38uB9jCDhGmS7Upr8IEobkLNawH0hhGO?=
 =?us-ascii?Q?tmzxMBs1DGutZfFxxW9/2lgG6v7X4EUhN/2NO2Ah1zECZftXg8j86vS+3Kp3?=
 =?us-ascii?Q?nLQhOYeRuszHqCL3TaYTT8NKCSxL6JbFt+/KGzkBJC0zkRM/9Hpvt9FdC47z?=
 =?us-ascii?Q?eukQfCgzRrxUyfSzKvtbpE+vO5gpZsnVxxe0RCtMBIYjzCppJ6l73Y9MEFKL?=
 =?us-ascii?Q?RHxPth6r8J7jGV+f9GF4dt/3vIvrtsZ/1b7o4lrQVKNtx7p1/wex9R+4G/AP?=
 =?us-ascii?Q?/2J/Mtn5ayzuoWfcma3iVYhvv0J0twtUZwRgRS1VqtzR5TM06Jk5JouP9PMm?=
 =?us-ascii?Q?ny1xJGODZJeWmPwAP+W9ByPoOdKOWZK/CjdtqU3CBb1dYsJXiTl29S9No27M?=
 =?us-ascii?Q?SvdF5d6Nr1Uy52DMPhUWplgE0dapsfhnUAa9LZpj+zhKno2QIo3WoU/aaK3K?=
 =?us-ascii?Q?3a81Dp8MnJ039V78Xwt2zrF6Oo0r2DvOPz3JueRia+3jOqObr+R0/qT+ooOs?=
 =?us-ascii?Q?9PXVOjkoHZVClX3n/O9bKYsLgv49mx6mKMAL0R0wWSkSGQiPgW1VXhKdQxVL?=
 =?us-ascii?Q?vT74q2KgF76BgyQNCrrF5U9BnCuZxoGEAew/KWGoA8ZD02U0RtIsC8W3bBwY?=
 =?us-ascii?Q?Tmy6J6HHIW1mlnMOo1u++1IqmSmio8zp+2hf1orJKEwltWkuIu34yBEA54Di?=
 =?us-ascii?Q?nVgIhHiTn39toJwchB73wvTFYXOG6MXuGc3vhkdmxEmMzD5ATJdoYFNvCczV?=
 =?us-ascii?Q?LeTfCGoKqxJbMDJySrR1W3Y//7qH18Leusieco2hQ4ZHK0405YDPS6i3LKu6?=
 =?us-ascii?Q?2ZkQSBORQ565A3EtRUTYVRTW6SZXQwv199sUWbz9mv3PlZ/1wXN4Tu9Jwc5v?=
 =?us-ascii?Q?0xd3QYONjsDGRWq7U61V2b89guhlJvzgaP+R9C/8K7O4YAidWRtSz7Ikz1RN?=
 =?us-ascii?Q?JRbERlmLkbXdVjB8IuJFFve5gpoD4nYEnCBarx6/Xadh5B7//fZ5OZ5R0jY6?=
 =?us-ascii?Q?/xUsOE2ObhYYtSNSiRBNiM3HQmXFag=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 485e63bb-7c3f-4581-5bc0-08d8c13b7a01
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 14:14:06.6516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EC4IJ1mPr5agF1kGHk101F2P1wfJRJTDjk2KyI7YmzH+lFZX8NEXxI2XkX7EFkR8eHiF+gjMi+E2/FJZke38g/gRXuu5GTvCKgL88N6T7UM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4319
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44394303623
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Jan 2021 07:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbhAZGB1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 26 Jan 2021 01:01:27 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:15164 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729016AbhAYNwX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 Jan 2021 08:52:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611582743; x=1643118743;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=kkA5mkVdr4tK4VndD8Pb19QBeES38CaHWeu8aV782IjJvHAIcNj1BUIt
   j0U/0woRdCuTH/Sn+nrAMiIqw4py0wOMphIvnBHD92cFqkm28+aFKr7OU
   MHkrcZjnM26rXrLQrGs3CTnMCBQSIVoq25M61u3M+d/tiOb+ctPCAjGAm
   5qQo0N7U5zlOsjvanAo3rFs+KgRz/9Ypu1X6Ro5uPa+lzVk+NJxe6KtSQ
   KiJVAdfnpj/EmBjX6iuZWT/wokpwVyIEcAlPtKqqmMPMlEPN0INs0Js7O
   AScbZd0Qg+4EIAM6NDBCwt7z2CmTkMXAQNytJYvUw8dxgBHjYtdRGlqyd
   w==;
IronPort-SDR: cTNFEceCeU89THMwRJ6J2qN6mabMNFKK671hb8z1ZcSRDoAxOiOnXTrx3iGBnJ1UaRxYOMgR3j
 k3hXwWxE3IwwQDLAY5c7GgRki8seBfSF9v9jFwCobIhTzzjhttLvy0Q+7RHpPBJVXe3Yr7DXDz
 c/TOgqtZw3H1+CDGfAZ3kP4T6f2n/6WDJs2QVUYzE5ypwGtj3xSW/9Gc4SlJuNJVPLX1E/Yo0P
 SWi0qjOpleWHlxZBkUnYkovO2Sg8fd7bkuCVgdOzttwfUHGZ161fFSNpbzhQMuFF0fcavf8ipT
 Cm0=
X-IronPort-AV: E=Sophos;i="5.79,373,1602518400"; 
   d="scan'208";a="159434226"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2021 21:51:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwwVos+4hHcvAuDGvwPbtJRi5WkbJeHSa2xIrHkLgeJyEXFE+vr7/czel4EZ5w6/mjfmk12hzJ6m2D1UckQP1M8Azbs2Wwh3WMe4NFuqkKAHz39N5UqGajWOAuWrVT1f/q9JOPj1Iec0HGY7c86G4hb4pOIEuTQWlc5eW4M4rINhDhGAOFKLDcUuT1qS8kOK49kOgUnONPimuRV2Ob98wZOmcpslhCLbgmPnjEcaFovAAGLkptjFHihfyYfKecQg0g3SoJ34UY39icq5GIP5vm10hzFPBiPkOvtk5UmTW1awRghS4jqLxBhLB1tUe9enPSqCUADonOku4g5mQwO0Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=f2m9KWBISBqw0Ym13dUqm8j3si6o3ED21sHv7eL5TgZsBpoDGdDfLgmz/6KGHYJ/LKbtpDgahN4JJg08dYu7jHh1Wg3NTEnEOV3GZjTgkWGDv3Au8ozLsyLzLTYqpmkzTJGzQmoYwmg0Ut8cpKiTMGkE45muSARZrwVZvUrpbH9k/Fjs7o+zQnAbgEIMUDbbz8FW06Jwe5wrxwvWmfwxGIXtYiHfWPaDCJsdntjey75nPqQFEhx6MG1gNv/0t26rJjQWm6Xv6MGX7QSnqHMTeOpLvUPoK9SfqOZ0zZ+jiUkag/dT2znzZ1aV/XFkoGLAWCx+knsW0jqKD8EI6MGNiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=tP0QRKDIJXxqH7af9tspeuQzbCI7EEhT8j8XcRgasKoxYbFzSyadC2q8qlBcO7Fu7M/tuEMBM9mN256ViZeWULyHWJrVQgdzaaI6umx797CCUhrhIjHpOBnAmapFiBro7IwwP5n6N9JcvufyKSJvtcIlRtLDo5cON2QOzaT84LI=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SA2PR04MB7612.namprd04.prod.outlook.com
 (2603:10b6:806:147::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Mon, 25 Jan
 2021 13:51:05 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%6]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 13:51:05 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 01/10] brd: remove the end of device check in brd_do_bvec
Thread-Topic: [PATCH 01/10] brd: remove the end of device check in brd_do_bvec
Thread-Index: AQHW8jiwwuJ8D6w9T0iSZ+Qk0m6aPQ==
Date:   Mon, 25 Jan 2021 13:51:05 +0000
Message-ID: <SN4PR0401MB35982F96772179339E14453A9BBD9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210124100241.1167849-1-hch@lst.de>
 <20210124100241.1167849-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3d333f5b-95de-47c9-36f0-08d8c13842f6
x-ms-traffictypediagnostic: SA2PR04MB7612:
x-microsoft-antispam-prvs: <SA2PR04MB761243AE27FDE64BEF44063E9BBD9@SA2PR04MB7612.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nU1Mk2FRvwuR2W58MPpSVIZ+8D3rXEcUWWb/d1oqsSmwldvd32TXZerkd1qR+39N1iOyWJ3u2YiX2zkb/l8USWqJe7ZiTHaV5J9D94ewPQguAjxg7GCFXo2zNT8ozZt5GP8Hy12mJpfbwb3M+gScCe4pGxq5cst7m0eiFGuEKTy4L0WujJ7zzAuzUeQ6VLPP3ZdyQLKxFMg/zd75dsFAOH9HELAAYU91TGDI6TLnrVgdWNySSddzYIKb2cDTir8D/rii0Ith1024MPIQAdWOhB1umdRQ7Sk9jEjYqC89ywMG1iYRxOqLlALVLkC9QueVNbYquvsckbxU+PbIVdkfMzVpbtObP+wnp1bYHAuhELzlDwhnD9PIQ8jryTW+AGd9NwpLHM2oyaPsn2d1kyJ75A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(64756008)(186003)(5660300002)(4326008)(86362001)(7416002)(316002)(8936002)(52536014)(2906002)(33656002)(66446008)(66556008)(6506007)(4270600006)(66476007)(55016002)(110136005)(66946007)(8676002)(558084003)(76116006)(9686003)(478600001)(26005)(71200400001)(19618925003)(54906003)(7696005)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?SYLvfzUGSx1iDkeetP6rvCfTyX4UdRtVnYU064X1rFBJQJyiar96NH3ZfIxL?=
 =?us-ascii?Q?QKxSsEWZlMZItS6HfOmtjfoRxuj6HhDLbTX7es/K+We0dDabUGfcFJckimAq?=
 =?us-ascii?Q?P3Bwj4QESJnnENLKKUTBfqiEK6CJQJ1HyNq8x2KHX8cHBeUGLUm7QDPHjOrH?=
 =?us-ascii?Q?p5rbFFnhBwGudXr6ZALMCGJULrZ9bnpjcjhM0BOq/79KMV59s7jEa1o3WU0a?=
 =?us-ascii?Q?HP+UeUOAGGuDQgBi7tuJ3XiXC7/L/AW+Eyp7a5JNXK3HuFWG1cugtJgb/tvO?=
 =?us-ascii?Q?xTrUIiy5P3Pu+EPMt3lfXXNTwc138In4TBI4qnsI+lYU7mdwQRnOnL3WmCYy?=
 =?us-ascii?Q?/c1OXV81m8qwnK5kme3RH8+fbIrI+Ec3dIah3PjOlN/oilt9vJoXTGJ2Pp4P?=
 =?us-ascii?Q?hnA90A4oLmtqVQ7dhgmNBA5VNooWkFJ6RL6GhuRwKRMoq5PE41/MLuMoDwFj?=
 =?us-ascii?Q?XomV8NWdGZQvyC1McnCkooEh7VQizG96c0GytQ5QZNBp9Kk5DyCU/+Hya1Yd?=
 =?us-ascii?Q?5iAIDpbWa586NY7YIXR1qmb2UNcvu+CwEqa+Wgx8w6IiINzaGUZobFg9Tr8m?=
 =?us-ascii?Q?mwMre6hRNwXluFi7g1AoJF3t8K3pIiSpDbrTyJ8DmVgHrpKR/PROKnk8f+NN?=
 =?us-ascii?Q?b2d6egovr/bjxRNzlioVk6fBQ80v01yCW3meYGTYd7s3xkZZ5voY5woMEdyG?=
 =?us-ascii?Q?VAb+yfI3U4fXm7hARSeG+s99RaZXCl0kIgiPg5py8EmMeihs7aGFGETUDNPV?=
 =?us-ascii?Q?5+h+qP9Po+VwNlDMjuq1TryTIXyi74yUnnCAYGBOzaKFkCFJI/Ihc+3O1zov?=
 =?us-ascii?Q?q0mi3AabG/k8nV2AvQp2jPehnkpi8vtTAS1fofZ59z47eng1a6Mq2wXnXGjF?=
 =?us-ascii?Q?ZbdlLo4uvq5xW/i/EJlBQmAtZWi/ha+kXC7M8/gJeXtsgCfDv7Y1ShmirVD2?=
 =?us-ascii?Q?UxhbSDynWVix1vOXo6zQhoFVA/v/tKFkOr8VjFCMp5brfH8XEZ6Wr9346npk?=
 =?us-ascii?Q?dOUv+ouq8IWKOtdNS75cmzFU1jGQGen8Nw6ckq2azMGG0oREQlJkbgCM3GFn?=
 =?us-ascii?Q?m8GLTZsyU95loMl7XkWP29MrXgzpyA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d333f5b-95de-47c9-36f0-08d8c13842f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 13:51:05.7407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nvh2FdmqvNtWZIuLkhy4dPT/oK4QDrw3SScRAJZ52O4WxgoyUu+pPFsy93WYQToSpJHLhgFHoDzZM4dTImEEC6Gtw6HGBQQ208KAvIwhBdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7612
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=

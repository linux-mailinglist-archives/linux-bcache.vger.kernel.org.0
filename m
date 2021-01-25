Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3A6303244
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Jan 2021 03:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbhAYNyk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 Jan 2021 08:54:40 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:64421 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729136AbhAYNxl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 Jan 2021 08:53:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611583271; x=1643119271;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=BtNfaQi6qJYlqfzSJgMusazLO6FbREkoXUGyqj7Wi68xaGQYgy8Qc4t0
   mT9Jn/JLo8wtJBPpwOybgdUNM+Zu9luoEHuI+lY/eOh0d8XB/eStYletG
   5LV5tf0oRMdOkoE4teGtbWOsN/wntdKpCMA6Ecf13012FaOhmGrcXisB0
   fva8mPs+cQx1tJG2o9XWMF4sfGtGW8l4CspsOxANC9slUK16KgT/KbHsb
   NwYTIdIeVj9uYer66Gi523A2/2Nw1evIdpsUbbbuXlQGPzdBxYoB760zT
   qD0VotBkpmRNpz+MYpas0OL82uoSPJLaanCfw/2+Unh/2ihRyAT8pxF4n
   A==;
IronPort-SDR: w9f7yEUHTBwXH9ZtLOs5/TOVOPlLhmMnitvBAcZH78kFCm5hRy37eqUkH32WYLvd0wuuvundny
 JUjSb4iKAorYOruy22KO4j5kXm5DSPE10b3LRvWffh137kdw7tMsdcRVqU+2eJVfc+PWz+o8C+
 wnO/AMVGbs6J8RlyeuqsEczMUgZ2fJ3tcj4NUp3GDoh5vnOwQH6zAnOILIieaKdX4p3Ge1tKs2
 wz5UVKeuuhGsBGVhktQEarEoqwwe9xWZlSdKQalGvBv5gmJ/LZpSesfpC11dGVT9cJ6Hdhj34V
 lVc=
X-IronPort-AV: E=Sophos;i="5.79,373,1602518400"; 
   d="scan'208";a="262261185"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2021 21:59:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Huy2TIXWW5A0L+UQHt5Nsr/4BJt5o7p6LZAePnZstSnIdVx/oYhCsEOyVRa5iYA/zavTWRy0xZ6bFe7tWiW40MMAc3JKCDqjNy/RkjMi1R7XqYbJCPiVTdK6AIk00wH41wLymqkyqqBtvLnKS9C7l/VQom6N2/TIOZVtFKmHvROLgHPDjtETeInaGDvl+0vcmOkrl5PYT5XOD4cFS4pJWYxLS/9IUPwY9BTEZd61gQBYGtmRL3Gxeq5BxsJO/3oYMCXMq4WUbKZIqTBBSjSWAsN5GvywZIdzcwxIloQNhykERfT9lPGbKpwd7FIondZruNdcDax6jeMB/r+CwY9vpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=SDbqW5uf7fl5/hzhiF9sMqRbpxBjdA0EZ/vqSoDVy5NGp4oaXBuceX4UYMdyV32tNxMXmNAIaIApd/5IkEkAGMkmJWfkaVQ2Kfh6QnqZrZwIvDWfXOuBD3LcD1C/YMjW+F3kRIU7Wlz4JGWtMwK0ceIxPnXbfq6fRLe5OtC/WiifIN0PAoBPMIKAGpsJ8kawaQ8XpHVYOQQioAURGZnxtXwgkBZUitUKJFfIFb3M76wvdM79XGCuQgKTQao+QnlDXyt/aPcaJy7EencTghJq0UpTYexD2AcblsxR+xOG6eom2/4pWg5xkZ9n59xFqS2hDuro+afSNLCE26kpvIUmXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=vdKs+UxI18D3S5nrGqVHOUvT8jpjKM7MtjZzfR0AJQMexzRrchg9M63PvH6d6yxeqXW+BzdEw3yvapc0X6Hq1MheDIjkGg8pTgLN3kuroXTXTRCQMkz0c54kXZpRlpofSb8AGSq7nG7HOKElaGsu6iDnErhTP1BxNKkAnZNsmOA=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SA2PR04MB7612.namprd04.prod.outlook.com
 (2603:10b6:806:147::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Mon, 25 Jan
 2021 13:52:20 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%6]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 13:52:20 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 02/10] dcssblk: remove the end of device check in
 dcssblk_submit_bio
Thread-Topic: [PATCH 02/10] dcssblk: remove the end of device check in
 dcssblk_submit_bio
Thread-Index: AQHW8jiwHN0LZhsDiEuvFiOYbsXH2A==
Date:   Mon, 25 Jan 2021 13:52:20 +0000
Message-ID: <SN4PR0401MB3598F6894E3789B7D3FCB7679BBD9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210124100241.1167849-1-hch@lst.de>
 <20210124100241.1167849-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a1e656bc-f908-4935-389d-08d8c1386f73
x-ms-traffictypediagnostic: SA2PR04MB7612:
x-microsoft-antispam-prvs: <SA2PR04MB761269F9E0177D9E9267E7D59BBD9@SA2PR04MB7612.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bU5R9tm9gvsBNXwaTw7lhZWx8a3ybA0DpqZLEQ5vuCd0GbwvvliXQ1Zcz7aRVsBwnudvUh9IyMRb94R/r1DC7Mc2nkztLx4jnPB8k9cLnlhsxo2X/tGwY9MSJ/43HZGMOyOaknzujG2bwmP7xRt6MTS1t1Ub/vJccUp6FE//bYpyUUtcfa/RgsiQfN4tI0mAbRySo0EgntHNhTK9aMolg3vULSVbYUx7D2Mq8PHBTb4H2ObQFGVb/1WQIdwMS8aC9hNR9uDIH39CoIBQmKWuI0+VERppoh7OXSuSMj1ssd23sD3FtMFx47xi9lfOC1EWd2EOM+y9CGJW5gjFQO7FdwZj9n69zFDcGgOAYd0DT67tVpZn5TRkqUkw9kqcgaCbo5VrrRf9NPF6dTpvn4cAoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(64756008)(186003)(5660300002)(4326008)(86362001)(7416002)(316002)(8936002)(52536014)(2906002)(33656002)(66446008)(66556008)(6506007)(4270600006)(66476007)(55016002)(110136005)(66946007)(8676002)(558084003)(76116006)(9686003)(478600001)(26005)(71200400001)(19618925003)(54906003)(7696005)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lDHqkrQZVyGZ31ML1d+IhfEcdPEiXrPozKBjdBevBrp1zpl2XoidpNz2mXTE?=
 =?us-ascii?Q?6/3WStXkE+FSLY8+H0V6yFVgE55XlWaToz4fvdYixnUNZHlu3JnJf8n9xKLf?=
 =?us-ascii?Q?WoJOR/lTCKliSW6wi+8ZnrJhw77ct+Nf9fvUt2qUFjFYvwOzEKNkcjO/0UfY?=
 =?us-ascii?Q?DTjfkYFJgl+d/2olcMOUtYqKaCa9piBrIATbU5zJichvf67oRdL3d4kjVtud?=
 =?us-ascii?Q?W5BkAo9PYzU1TpfcGyuDox8ipXSBAEwV4V5s5BEpFMCGQb6ffamau+h45y+d?=
 =?us-ascii?Q?k/g9e4/YuyJDsnNFKgHmg161493sJutWrBkIegyqz7NI/Ybj1SUBdYcdEd5Q?=
 =?us-ascii?Q?qjSJLlV/+JJjE9dRaAVyS/dhLUjC4f218fn6rCzGBNVQibzUQLdZgAMxtPSQ?=
 =?us-ascii?Q?jSGGD/QcWf4xkCnAUW4Z9Q8HhOYSxiveujCSJskhfdcMlJz7KNnQt9gHBsYo?=
 =?us-ascii?Q?aJIUyUKAjWbmJDWxkCA//ZQbn7/bdnxVSilYIU3YXg6GrpCij4hLMFsLe54i?=
 =?us-ascii?Q?DHjeS6s8QhFHyRP9hv22rwFS6sN3tnQfkzSWp8VMCs4p+fXVDmSYf0+7vH2m?=
 =?us-ascii?Q?CzeEM5ZFgldTFeuBpw8jKB7kDuPHfileuYYuK4XUDLxlS6QZy5xsj22vpk7L?=
 =?us-ascii?Q?WAy7d5rBm+96PHxnpnVSCyJqKZDfIiqM8cQiwk6I0a7/0SnzsEtGs4IYt0FB?=
 =?us-ascii?Q?NlZvHPzsowE2Br3d7ZuHMr713Hn1PArjvlD8x8k8wZMvoEFVxYj1MYJvIuFj?=
 =?us-ascii?Q?+yo41/bbTC3N9+wMoiEczrV9E5SywMRR0MIHBcmwSbnMhDURnABRxuVWfrga?=
 =?us-ascii?Q?SqZ2wo7S2L3vyFXE7Sx7g2g9/Jf1lUTN5dtMeOzcITLOnMBfBX1vjBZeotoy?=
 =?us-ascii?Q?S15nHBW15drWRG78GsnEDMxEFI6w+OJr/hty1rSC/25m0/fvU+UHXZJmwNPC?=
 =?us-ascii?Q?Bw1QawKtheMInGW4gxGvqE24WKa1fOtgQhu6FXUNLln19F1ddlMNC+MDTg+z?=
 =?us-ascii?Q?oywG1pcmKG73YoufraIiF4Zv0NC+jAkI1sICjrZEItLHz4s0u57a0R//2RCn?=
 =?us-ascii?Q?XiDd4M+sH2ypNbN1pGOzVPvhXmf7qA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e656bc-f908-4935-389d-08d8c1386f73
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 13:52:20.4127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cg1G7xyT10MPoHu/nOwo5LbZhouchgS3A+abYpZxs+RvkR1G/A5gL8sBR27JsumSYIw638q9hWajJ3kcMMiE5JBNWe7gKtPKidupxFHsrFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7612
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=

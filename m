Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF8D52E3D2
	for <lists+linux-bcache@lfdr.de>; Fri, 20 May 2022 06:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345268AbiETEd1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 20 May 2022 00:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiETEdR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 20 May 2022 00:33:17 -0400
X-Greylist: delayed 959 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 May 2022 21:33:14 PDT
Received: from CN01-BJB-obe.outbound.protection.partner.outlook.cn (mail-bjbhn0106.outbound.protection.partner.outlook.cn [42.159.36.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7689857B24;
        Thu, 19 May 2022 21:33:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FfiRGDolRxBbTPU/pW5r8wSRx822XdrEAsVxaJEH6IeqyAMWV+Z4Jw8Ad6X2ngxB4bI/3iSE6598xZy8rRmhdDNTkFgxzqsUZRD9/IGqGUPoN+q8pDFIcd1ThB4yp0PKoplGZwv97L2L+hQcunytsc0jVn19ZHi0L4VSqlGDhz6GvZMXqBdXLpr3XbdgFngjkXDRPd4S7QxFbmmATZ7wM8lTKSl+2QwAik74tBSFj7JRNZjY0ZG+1dPlwOyyaC+sxhQox4gP0jsHgdA+zLlxWFlDYmRW0+jVPlctd0kgsTO27m9TsPUwZqocAlGwqSCMjCfJxUQL/8jZleoMtGnL9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XHa7Vpxtm/u3S4otqoZTmpXUuVJNGmaT4A6UJUMDuKo=;
 b=n/ga3Uv5bOysJiwFWtaASbc1sOVT/74FQDrkJ2T8Ux5DI/ZabOZC971JaHF4kuQ3K6lCbPiNC7HEABwD5zLxg9JNOyrLeOLguG/jQUvktm6lr7+2XdJDLwMweVB9sI74tto4TRLvb1AayvptZEGfujC9DBcewTiKwQirOdl8MmQPGHKPMfuJQsB3vHlkqyfLywSsTt4cexu/zSsGjfqKXO2BqB1tbmaB3YZ+z739+BN29/5UbiVaprQF3kTeGijgsLTVvix5Vy+tZ3Mb8QxFecsH4gwEFQnCAltBxiGp3/y6BB/pEyIRpVIIxs0Ptf+tneDUMg2CDnRkb/BhaA/PWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gientech.com; dmarc=pass action=none header.from=gientech.com;
 dkim=pass header.d=gientech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gientech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHa7Vpxtm/u3S4otqoZTmpXUuVJNGmaT4A6UJUMDuKo=;
 b=XfVm/EubM6OiCQfN7/lg4sqD4IPx+r0/o1TwEmVWbLmvLortvEFcHt/UrT+2bjS5HnXyhykoFdj6kYO5fdpx6JqCFGwQwK3wUpUZ51hfTfzN2J+47ZR2SXZQrxs05rNMsn39e09+9PxmTTpfdC2FJmKHe97TEQf5NMuq6LKTKsaU7HKNsNXs2Tl/q0ZvwnBPibW+hxEFMq/oOhCCgjV3gD8FCaal4Dakx4u71iF8SI1ZyFAwgSGU6CUToVPaRcs7VMkCl0pHCLrLvvg+F8N4RkRBqGzd2wKmZ7wUJnnhPbuH0gAnPswrfdPgMirk2+aKzvaicl4m6lRIMEDJlBsI/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gientech.com;
Received: from SHXPR01MB0623.CHNPR01.prod.partner.outlook.cn (10.43.110.19) by
 SHXPR01MB0589.CHNPR01.prod.partner.outlook.cn (10.43.110.81) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.14; Fri, 20 May 2022 04:17:12 +0000
Received: from SHXPR01MB0623.CHNPR01.prod.partner.outlook.cn ([10.43.110.19])
 by SHXPR01MB0623.CHNPR01.prod.partner.outlook.cn ([10.43.110.19]) with mapi
 id 15.20.5273.017; Fri, 20 May 2022 04:17:12 +0000
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Ree
To:     Recipients <cuidong.liu@gientech.com>
From:   "J Wu" <cuidong.liu@gientech.com>
Date:   Wed, 18 May 2022 21:19:04 +0000
Reply-To: contact@jimmywu.online
X-ClientProxiedBy: BJSPR01CA0002.CHNPR01.prod.partner.outlook.cn
 (10.43.34.142) To SHXPR01MB0623.CHNPR01.prod.partner.outlook.cn
 (10.43.110.19)
Message-ID: <SHXPR01MB06232172A0DC57B58CF67A4889D19@SHXPR01MB0623.CHNPR01.prod.partner.outlook.cn>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba276e27-8720-4646-7691-08da3914169e
X-MS-TrafficTypeDiagnostic: SHXPR01MB0589:EE_
X-Microsoft-Antispam-PRVS: <SHXPR01MB05890B7A1489C9328D6E90E289D39@SHXPR01MB0589.CHNPR01.prod.partner.outlook.cn>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?Ec0EgrdeXOGmSK6mh447SC13OYa4/8Z1mL4OwOhTDN9QZ9LPcnPNGt9DEa?=
 =?iso-8859-1?Q?2NvRQGN7Kj6GG3zgRHnC1s2ojzKoS9huHDbH6xPBcYfr8rQ2BLHvGhJYC5?=
 =?iso-8859-1?Q?QGC14nnTvN8Tv94D3hnbEjPN2ShqBreptLwSImOxepo0rVVkkjODLLW/Yy?=
 =?iso-8859-1?Q?lLhV/dLkk+6B7LgQHZpgWe2o8KBzkicZU97nV0w75cDz7lvmdkf11oO7m0?=
 =?iso-8859-1?Q?f83eCZEKbuzHEg2yp4Bbigy2uGWV93cpd7IHgO19loFqtejuD1LyodYS+u?=
 =?iso-8859-1?Q?LyUZikdUA99npGohUNAhb35tkMYtwGsKzxU7sQMTAVblgptHOONxEeD9dF?=
 =?iso-8859-1?Q?WDkjPUJgZRPIVMK3H0I08b6jNFfw5048MGAZ/iHMDoMy3pz15U2FYHLdPo?=
 =?iso-8859-1?Q?p2lvsO72zd8M+VH9P3H7WdYlUJIwC55xfEMIbvgs8N9pNh7zR5Aw54g7lV?=
 =?iso-8859-1?Q?7Cwrc4l2kxxWyaeqigqHnTD0BXohZtKWJy9Gya1saaEzBMGxRk0R0rWONb?=
 =?iso-8859-1?Q?tKLmMl6qizqnriRLslgcExuvyHeLniWQG0m7JuUtHAzlG/vYcQA1xAUFUW?=
 =?iso-8859-1?Q?YE0iqoODGg4LpLkXRLIf7LVvpLGniJ0BfnXggh6KGsY3nbw/URQVZj2T9c?=
 =?iso-8859-1?Q?u0/ETtCOL/RaoZg+o0MvDiWPTGbXleE1fnMcKEsQn4LQVYH0tCSjKw6BLA?=
 =?iso-8859-1?Q?dszybQ1IT2T+e/Cisaj7RLi81h/BKwZyRsrzQA3XOuh2MDsadgJMuVcgTN?=
 =?iso-8859-1?Q?611blMEgDhmf4HN/0dExa/oflS+MmMwCK4xMp0eisTYbnWgi7oQyz/glbn?=
 =?iso-8859-1?Q?6Q5mAr2+OaXui5Zwcu33LGHYB2sdPkZZM5r7M2Uq4KxcxsnFX/tKgtx7LL?=
 =?iso-8859-1?Q?wl5K4gc+XnA2IL5SshuaO71iZHIyqXs/I+XsR6JENqeXcpJvxNUWTK7mc5?=
 =?iso-8859-1?Q?YZ09IT3Epr3INzM5nZNGwaD7oNjzOEw3vAI9jkgorOsXgNDiKOLtGVxTIL?=
 =?iso-8859-1?Q?zpcn/8y2XyJeGCO78U/SwmQxOuk2MSjGK9FXEMi/SVy/aOcS/ssf36mcxb?=
 =?iso-8859-1?Q?qg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:SHXPR01MB0623.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:OSPM;SFS:(13230001)(366004)(508600001)(6666004)(40160700002)(55016003)(52116002)(6200100001)(4270600006)(33656002)(8676002)(186003)(40180700001)(558084003)(7366002)(7696005)(7406005)(9686003)(66556008)(38350700002)(38100700002)(86362001)(3480700007)(6862004)(66946007)(66476007)(26005)(7416002)(2906002)(7116003)(19618925003)(8936002)(62346012);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?G4dPnVYrsaV28QqvBeJcU/CUn0munwo845DYnVyMiQHoC9ox7ePknkAWUB?=
 =?iso-8859-1?Q?UxpzP+TNbh9VopEZSz/QyEFFAh2da5iLSU0wF9OnPvo6TvxLJVWVODBWIt?=
 =?iso-8859-1?Q?buwDYpEIhKjENaVjlZQszzLb/8rE+xaheMTy7ZrdIYv3+wIKVC4wxIIJjB?=
 =?iso-8859-1?Q?1VeDOtBvcYVqGHFzSGDM7HBafzGcFEbwR82efTVBnbNlxKTiZV3+1iN0OV?=
 =?iso-8859-1?Q?THDqP+XYLNA2Te66brIu+bamVRcg4OkFBlIWMvRHIoVfII0s1EA+jHp3jx?=
 =?iso-8859-1?Q?+sKC1SEqBC64u7aSkVue8EmBA/Cvx2LGhY0IkQWwEDlRxwawoYs8xS0IwO?=
 =?iso-8859-1?Q?ppSkeuvx0YvDsU9kUpMo87Z0vEo91/KxG9Hlx9fBhbxRuiliEGkgDXCXcE?=
 =?iso-8859-1?Q?mzxw3/OQp5xriZfNs880lGA83kszXEjY0YgNlOb52iUys2/CynahxIpEJq?=
 =?iso-8859-1?Q?nXYWIGdl65meGWj/l6PoEAHwuFIx4Wd+cQbFR357NroNFOKbK3Jzj40obi?=
 =?iso-8859-1?Q?KYzDY69FEGsF06ElZDoAab4Jux2pVHk9ku8UUIa2L4HoEccG8tq73llx2b?=
 =?iso-8859-1?Q?lQ7ToCCdnxWW/eHtdVrzS4VfO0frKGvyvaYjcCFlLfCx4jFZt2adXxieP4?=
 =?iso-8859-1?Q?820oiqT/ykARgWprWzUa5K66TqG7ZYTecc/VfUxKT3SO/gIRuXmCf+8U46?=
 =?iso-8859-1?Q?OjUiGXvYAQ7Zt0l1EFRSPtlLtlPUhXuuyOipVIpGPb4jMJOgdqa3sudmgG?=
 =?iso-8859-1?Q?VO7J561VxSPvOo65cwNkrFLd2B6WXnCDJBaE57L7HJVPSdHWHVu0VxIQPC?=
 =?iso-8859-1?Q?L6Xj1oifuhvziRkM9H8b2+cCgkfARuUHyzUHAog1fnm2StqcFarEi2G7i7?=
 =?iso-8859-1?Q?GhvlO3H36E4UnodqnQMUbU/HH6LcQGuBlh6b0eW1x1iuxQDvc4cr/XFUdh?=
 =?iso-8859-1?Q?anGZ5h+dpWlhhsWxxkOlmUI5zOeXi+XhtqXYJaqSurv/pKzC5pNFgDmY04?=
 =?iso-8859-1?Q?7Yx24Nhz3R9xb7CUvisG+tBLOtuQVtvmKQkYbcO8m4xU+gC+lgoWLNzE8s?=
 =?iso-8859-1?Q?ZGjT+FWIIuZecxq5KImN+vOvW820lXFmiOrFeDjghL5nVNgvWuhlVAqWQh?=
 =?iso-8859-1?Q?PQeONGJhgoP874yZzboivNC3H2cVltdsEzEBOaj7UDE0rs6rrtN89+p1rk?=
 =?iso-8859-1?Q?FDiSaHY82p+GWPn9/Z/Py3E2y3lSNI+3m/0j548klrUd11wNPdRZdxp1FN?=
 =?iso-8859-1?Q?BcAGaKJ7APy/Hu25IosgF0LWbRP0wgh75UE3T7yZoXr9OabfvvJ/Aorxrk?=
 =?iso-8859-1?Q?GafC+zfUheEJd86Jfogv2apocVbnfjVbyQOn5DPJMLawJAvX82rgiJzxPD?=
 =?iso-8859-1?Q?yFgm6NNqTfKbEVpOz2uWj0Apwp36GMrIzWuAfdTwQNeMOArbYs9ZqXBraN?=
 =?iso-8859-1?Q?0HBU3jB82OlY5IAm13Omp1ckfUqqtvPHI3dkC0TwBiMOhuwsajY60Rbz39?=
 =?iso-8859-1?Q?lS2z4tp5wukpEHLIrzG8SkjXCsddpUk/2ZSxuztWz7l2qXkm1p0y9dOY6C?=
 =?iso-8859-1?Q?V52ua2FeZv6arFFrN0Mejbn2BLpD/8bHn36bFUBzHLh2JxxswfGUlxfeJR?=
 =?iso-8859-1?Q?lCfUQgEuRazwS9zhKWpQV+NprpLPHtTnSsfTY1m1lZuS8wm0rehnqabX4S?=
 =?iso-8859-1?Q?0r/6/gCBnb7dxEG0arZqksmck1Yt7feI31kvhRYJjTDgjfyLsJ+ae5eRHf?=
 =?iso-8859-1?Q?oF9Q=3D=3D?=
X-OriginatorOrg: gientech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba276e27-8720-4646-7691-08da3914169e
X-MS-Exchange-CrossTenant-AuthSource: SHXPR01MB0623.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 21:19:26.9053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 89592e53-6f9d-4b93-82b1-9f8da689f1b4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SPwlG9RaRId1GHt0oyC+Vz4ha1/1VBXAT1+gMaxndMUIubukuE4KmClrXWoLXF4WU4sNb5xKyy8aJ7mEl75U6rPtSLtECRNGnFx4CZp8Mmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SHXPR01MB0589
X-Spam-Status: No, score=3.7 required=5.0 tests=BAYES_50,DATE_IN_PAST_24_48,
        DKIM_INVALID,DKIM_SIGNED,RCVD_IN_BL_SPAMCOP_NET,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Can you do a job with me?

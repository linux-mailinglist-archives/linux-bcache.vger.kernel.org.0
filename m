Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52B652FEFD
	for <lists+linux-bcache@lfdr.de>; Sat, 21 May 2022 21:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240657AbiEUTmz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 21 May 2022 15:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiEUTmx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 21 May 2022 15:42:53 -0400
X-Greylist: delayed 5810 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 21 May 2022 12:42:51 PDT
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02hn2236.outbound.protection.partner.outlook.cn [139.219.146.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664143E5D3;
        Sat, 21 May 2022 12:42:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDaP9z5z7i+uDngld6AQ7ubgC93F8hupvW6QVuAJUhFIFmnNzX/MVti7+xLs2AHj0zJamZDCatCGYtdi/PcGHBiwCkhc+QdT2PZKb61ucrV0eq6K2bOQt+TjLiv/liG6a3+NzEx5owoOjF4txSytTPWpunjnmK64ojziTdGArQIT9qZXpY5V37XFu1fLjzqH62hu3HwxVwFGIRpg6oGbv6iDTYF4On2IVtsRW4a3MkNIc6hJqhScCq8jGj5t71pqXkhQmPRdVaEOC8vFBDAhNMZj9O5yXwO43OMKwKXxVQpHmQyK7dxRI5oXuj2MgECBMhZ+h2tRDgvarbmpVuusCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3z5uhVUtqN5OyplYkKXQ17d4OAmlRJ8nVcEl3nfclrI=;
 b=g/VWVAL8bj3lmkONHi3LK3qqZhjO3G6+4lsdumTotBG0cVOr2Y8BRT4jB5nD38s3y0ngOUdyECb8XMmSplDCVEcFLv3oT+uDxL5m+i31VO1mE9+XpZl9kXH2ykBstxyJwS/lFGITCz7kk9SdJ8/lmfzDdoEmdFZLrcRQlLyGXPZxNvc6+3ELqaXqAhHc0fJek2uw6Pu+sbCEa7mZ8OtqDljollYtKqbEHxE+OxAMXua1WkT85RXKPa/eCb9+TgldtDtOk8MgbMx6zsfCJfSf9HHKVm0/QlbvsBllyk4lOn2f7bnEjFa0Rnh2b1Kxl/q86YDha9GR4FikQDkabymX6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gientech.com; dmarc=pass action=none header.from=gientech.com;
 dkim=pass header.d=gientech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gientech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3z5uhVUtqN5OyplYkKXQ17d4OAmlRJ8nVcEl3nfclrI=;
 b=tlXkEkdiRaFwuZhItkCokjk3vK6NgQ0pVKMSSuvKm4pMVsEzVyFvDKruB/IjVIgxLX1QoeD80pFf05ozDryx4dWSAKN0oiUlxoaO5yhKb8JrQEeCuAc4joKJ6JpXPorc1JtfNnyNBij/LVBAMqXU1mdqNgbTQ+4t3m7h65aqqW349dOK1LStzb+8PrhPDCkyY+lSz3iOSuWFbg4pDh/DiFzHWq0gJbnqcKADB7GRIVLgkSN21uFiisG6DNIe+PqiRJvpjJiSCpSYOK4iyPw1s/Ol4PMsZ5hNwV5f74TW0bTgFj0jnFITYDfk2HVdSwXkFDzpuzSDA6PehlwBtsL8cQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gientech.com;
Received: from SH0PR01MB0729.CHNPR01.prod.partner.outlook.cn (10.43.106.85) by
 SH0PR01MB0506.CHNPR01.prod.partner.outlook.cn (10.43.108.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.14; Sat, 21 May 2022 18:05:48 +0000
Received: from SH0PR01MB0729.CHNPR01.prod.partner.outlook.cn ([10.43.106.85])
 by SH0PR01MB0729.CHNPR01.prod.partner.outlook.cn ([10.43.106.85]) with mapi
 id 15.20.5273.019; Sat, 21 May 2022 18:05:48 +0000
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: RE..
To:     Recipients <tianjiao.yang@gientech.com>
From:   "J Wu" <tianjiao.yang@gientech.com>
Date:   Sun, 15 May 2022 12:39:10 +0000
Reply-To: contact@jimmywu.online
X-ClientProxiedBy: SH2PR01CA001.CHNPR01.prod.partner.outlook.cn (10.41.247.11)
 To SH0PR01MB0729.CHNPR01.prod.partner.outlook.cn (10.43.106.85)
Message-ID: <SH0PR01MB0729F8F0A7328A964285972D8ACC9@SH0PR01MB0729.CHNPR01.prod.partner.outlook.cn>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11981dc9-c2ff-42b8-d15a-08da366ff626
X-MS-TrafficTypeDiagnostic: SH0PR01MB0506:EE_
X-Microsoft-Antispam-PRVS: <SH0PR01MB0506BBF60DC69F991D92B4468AD29@SH0PR01MB0506.CHNPR01.prod.partner.outlook.cn>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?VPKpA268NKQCGBbMcC/DsMNsEqYgXx/l5fU1NSIyAeTLfK2TnnRgSd4wAB?=
 =?iso-8859-1?Q?tBe0I+8dmdPXHTGVhpjdiHYqUVJfC6nUndKgxoiyy/tFgKv9ciJXEueQm8?=
 =?iso-8859-1?Q?wVx7IolCOjWs4zly/fAhPyxHz0+XyGo/MU0QvQPDiJd48iUHeWPd6JAzqq?=
 =?iso-8859-1?Q?iDddsjSw9LiJiK9BouEyc1uf8GwEd5HdtpiUrKDVIprqTj2caJ8Y5t5Sxy?=
 =?iso-8859-1?Q?gVNIDFG8N46Rwykg17Bwh2ay+KkruLmIXHO04TMRVlJ2TexgFBvRyCYokL?=
 =?iso-8859-1?Q?NX6lUU5lzKTbY9xm1rUTj+TAffzrn9loLd9ZnXv4u8HKkMreyvBIVf21sM?=
 =?iso-8859-1?Q?ciUWO+Sg/jXBpG3iH0W9VRyvh3/p9nsIR67UmRYnHR3kjLFTrBtZlvGMfS?=
 =?iso-8859-1?Q?rjj9EIdPXEC+SYphaSaudVjV0JTmqXQyYrSe6TVYKSQbgd2fs+ZYwEfgie?=
 =?iso-8859-1?Q?dvZsZ3x5DQOS5LUgMyik0s7E0ifvvotStL39DhC4ajgL7+D+lW8khvpw8z?=
 =?iso-8859-1?Q?dWsVHl/SdVlsqVizSRHuOt4ZHAJh8ibEVuC53/C0FiFYBdM4cDt+KhXTnv?=
 =?iso-8859-1?Q?jMcN0nueai0zCzqUQvf0v1rnGb89zEDZSoD/Lh/ooIRh982lrV+652+2pg?=
 =?iso-8859-1?Q?MoVhpKuGhDq5JLa2mhQ7yhR+3Qv/tPpkwLsBul8XPJLY84qoSDCNnE38Ih?=
 =?iso-8859-1?Q?O+apurDMyFWSYtGsGpCO80vNwG097DnPr62j9yK9/BtIIR8RBhX5Vpth/V?=
 =?iso-8859-1?Q?hqmBM9OMuDE+doJ7QH0ZgFayFhvd9anLSCnYttlAGZlSNQf9SQgvew+HsD?=
 =?iso-8859-1?Q?yF1kZWK+uwvl/ba0+HCVEOQ2oAn9jyPiCYu+ic4QS0jV+onfMuF61jgDSa?=
 =?iso-8859-1?Q?7OASQwkexIPP2f1lYSibtB3aSexICp4vOzIGUuJ1liufe/hi8VgV9XU19Q?=
 =?iso-8859-1?Q?2IibHUhdoHQB9dAqlxZzXLgEE2eYvN2gAfXhzDkDl7xth+4UqQv+7SzKgf?=
 =?iso-8859-1?Q?hOS+8iu03FXNGPyRkjRJa0D9PNGY2gLSAgrLGsJJUrtoqYerVChHzchwaa?=
 =?iso-8859-1?Q?7g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:SH0PR01MB0729.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:OSPM;SFS:(13230001)(366004)(3480700007)(52116002)(9686003)(6200100001)(508600001)(7696005)(6666004)(86362001)(38350700002)(55016003)(38100700002)(26005)(40180700001)(19618925003)(66556008)(66946007)(66476007)(6862004)(7116003)(33656002)(558084003)(2906002)(186003)(8676002)(7366002)(7406005)(7416002)(8936002)(4270600006)(40160700002)(62346012);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?lcybKtZESJktHf+fbaQvEUjI0uMmR/JzSbcBo2TwCu2gDrVde3RtiZomSl?=
 =?iso-8859-1?Q?gu/LIpez97uaP6fW/DDa99pJbhloSxR4V4Wv/rrmO+XTAYyVxz2cjEceLR?=
 =?iso-8859-1?Q?gqrVvT+kGUcaNp6kyMZZzOxIwPqT1nOnHXfBTon3KiUXoDfugzjWMn2pXt?=
 =?iso-8859-1?Q?Z44OXk77vEpFdCLbloEzR6G2BptaYjbtm29w3+YKtLqHUVMp3nZOTgUfAK?=
 =?iso-8859-1?Q?qigJNC2pHddVfUNAkYamhOjtLuM73KboKVRv21t2oFUcLNV+Zgb5tsZvQJ?=
 =?iso-8859-1?Q?arheSNUh9CHQVkgOhVtChbUJlUqN10izp/hVZlUi21Ytt6zu/+EG/4cCJk?=
 =?iso-8859-1?Q?Dvtnerk2iiLfloc8TzZkKG6O8o6BcYcto/poZ6lndzHPut95r5jiWK6S0G?=
 =?iso-8859-1?Q?ZDQHbfx9i4zWs4KCgCea6lVL8hfR8oiuqvsJ97LtcZr+pGN7JmmexWz1Lw?=
 =?iso-8859-1?Q?aW+UN4aaoOSnHrQG20QV5Pm4moiU0Qw0zhZ9WXLIh/i8BAut+i1c3KLVRt?=
 =?iso-8859-1?Q?y8qBGCxz+YDWw1vkk4dBh8Yrmko8EjEFB7z6/W3tx1EG2bp/fa20S0ldeF?=
 =?iso-8859-1?Q?7cr2NF2TwgBgzO+BrNgLnE5J87lOnIor/1Ln6RtPMchmPpjotitzArU/2s?=
 =?iso-8859-1?Q?0gIyXNBG2Tt5WW+CHX738G1VvzHpK+MVUPz71Pi8ywFIImf9L4YSEIAmfD?=
 =?iso-8859-1?Q?sezVDZPmmmIX76/LD74Xdl0DQnBsrpxJQYire8tM/HTTWCtArD8fpEmmZS?=
 =?iso-8859-1?Q?TI5W2d4taqqMQKS4WOewqFxaVJzmDUPdN+i5gz1ot8e9FmLFga3ppcPPuw?=
 =?iso-8859-1?Q?kOA9mcqwkTjNgwBeYz0wNQVay2+zp4/54j0yuslr3KElwAQpoO7DqcZa66?=
 =?iso-8859-1?Q?lX6s9yajJrXnicETAUNTEwIPHthTn4r34QyYmqvH1uNCe8NZj0SWGHdGJ+?=
 =?iso-8859-1?Q?nf1rlh1ARtOB4vRkRDXQo+q4IZXRDTHrZKLimNs+IowmDyUvRU+a6sazr6?=
 =?iso-8859-1?Q?FZ74FD3N+hauHAUMI6FysP9vrXyhMd8NBI+dsLo5nf38uhUoWq52KvLlO5?=
 =?iso-8859-1?Q?2HWATWdh5L2dO5DnYzY7yPOd8ey+L/Cr0L10iFg38fAblrO+lzBd63BWd1?=
 =?iso-8859-1?Q?+RcY7XMgpn1+VD1dVVEjtBRbPk4lUy0xZi7cJHn15Ay6Va5Zxr82UA7ege?=
 =?iso-8859-1?Q?p+7i6yyKzBENxqGDRU8unt5XWkYv5yUgn2yiL969nZxWObildQHfKLwrnu?=
 =?iso-8859-1?Q?YTyUJJdqOXvdSiX8GByRPhkHC/AN8TTi/HjhA1p7gOEPM9BhkAoYkibNiG?=
 =?iso-8859-1?Q?J8G3mEibkBiU6jg/nYfEGQ50ftNoc9fEU4wWz8n4Mzaxn130lb034ZWcxO?=
 =?iso-8859-1?Q?oaq5POQDeZNYYX9Vs+UQzodkrRTh/vRSlV6AUjJtB/qBtgnq2RfetIJSmH?=
 =?iso-8859-1?Q?6lxf4i87sn1NhMsXtraCDINztmdVqI71G8dMlrmnaQRealJ1F1YE2Llbog?=
 =?iso-8859-1?Q?dblEsAXT7PdbMBCBkGkpzL58Ze6WfleR8YTqOXcxmUnoBYGgF4LBqcYZs7?=
 =?iso-8859-1?Q?aKLNkORwLmFQKtVJcZOH/oe2NnQvMh2RIVxIS4hGXNH77rJvMEBM2ojUDZ?=
 =?iso-8859-1?Q?iHt5St58FRrtXaHC2VGCf6Ya4/NHnOD7x3VMvW6RvH4TFdBgH5aqItMr3j?=
 =?iso-8859-1?Q?r+xtqv+XJwanFfl3q2AxE9l0PYb/7TfBEC/9l4PQLI578oO1ph5Ui3PGyq?=
 =?iso-8859-1?Q?YjK259PhaMxCJWCzVJ8bfQSGQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11981dc9-c2ff-42b8-d15a-08da366ff626
X-MS-Exchange-CrossTenant-AuthSource: SH0PR01MB0729.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2022 12:39:32.6761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 89592e53-6f9d-4b93-82b1-9f8da689f1b4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: um7g0CyWNeDuUrRG3WZNZIrdFT2eLRxv8JnAzmDnnyqcKkVPnYGX5c/Qo8ecN5ylQ0X7yTAx7NFeY249GP39UeQG4Ecsx//InMoR5I2KJzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SH0PR01MB0506
X-OriginatorOrg: gientech.com
X-Spam-Status: Yes, score=7.4 required=5.0 tests=BAYES_50,DATE_IN_PAST_96_XX,
        DKIM_INVALID,DKIM_SIGNED,NIXSPAM_IXHASH,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4492]
        *  3.0 NIXSPAM_IXHASH http://www.nixspam.org/
        * -0.0 SPF_HELO_PASS SPF: HELO matches SPF record
        *  3.4 DATE_IN_PAST_96_XX Date: is 96 hours or more before Received:
        *      date
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.1 DKIM_INVALID DKIM or DK signature exists, but is not valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Can we do this together

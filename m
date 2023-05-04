Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF266F6DD1
	for <lists+linux-bcache@lfdr.de>; Thu,  4 May 2023 16:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjEDOic (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 4 May 2023 10:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjEDOic (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 May 2023 10:38:32 -0400
Received: from GBR01-CWL-obe.outbound.protection.outlook.com (mail-cwlgbr01olkn0177.outbound.protection.outlook.com [104.47.20.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891D4118
        for <linux-bcache@vger.kernel.org>; Thu,  4 May 2023 07:38:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRz72o1yz4/U8r3bksZ6ZH4HjTWTtVY5fmMfPJ0t/knHUKbAupqY4zJczPLACQyR+oU4vvXeFCquDlFUeUlKCLnEcVowUWb0XGnjNRLoFTR/ow1XgQxpbWo/cMLy+4dcLSnnt20V5eFL17kD/8nvvu2Rldr9l4VNMQsoHcBfBFqprp88hKrfDpvWJ2TIhnsYegTgIDzYswKOSHJr/PGej5h2jMT9gCUU7dpQuN5Ok1nyVb2TPZk4ggFsLNWGm4V2tAlBk1sYLt5tNndm8WSksUp5YRYnQ8hxcogvNZWLMsIyAz7Dzvm++uRtksoY3sjSrNcj3ChVXuZutSZypFPZkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GvU536OmCOBtMmOvPnB/AsyOS4Fs+ZjWanGuR5+OSGQ=;
 b=CO98qJbsJEXL87HS+7bcuH7sz6BXcmCsBTSN10Q7eeuiSPqK5MxpkXAoQOmYMy939FJZaPJHqe70teyrtPlvS4WDAj5RViYlIRIiqq579AE9cSBRuORcCCfQKqINA8FPv5+WmXjAM3WeGWrWT6YW0mFFdo653v3qha+STXDH+Y6o3OROF1yszVRKSULRLbezs4CrAC63jIQ4rgCV8ITY48kL9p4g7iZ/MzW5iGixDLFcsMhed+wJDU3UuISIEEy/uyd7Qetwthyqo8TWKsT/oPM6g7jtzW2V+BHzZrycuU9kSYEfP+1bBBBmseDU+yMRThWIz0/c73UEl04Ea77Ztw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvU536OmCOBtMmOvPnB/AsyOS4Fs+ZjWanGuR5+OSGQ=;
 b=U51uUN5HcVI1ThvijDcvuktjeMriw0GDczme45Vf0e9uke0cSqbBEAHoDuDMDgvjelFkhjd0eGz3IusFr/c9LNoKMmNt/FcWYhFwDL5EHFoiITsSVbPJQkyIKq7/4LML4BHS/u4APwyTD1Exmfj3zu0phKiCCKHi61jnwwprKiobfqR5oX0nE6lLpVPor3OTtIeukYMTJbHKMi0+vOhr2PFhHI9rPzAtR9Ti8ytiv1PrugFCVo5jMzmiFVp8tBHNL7HSvXMMzWyMIG0nrrZzIQVH9nOovIBRVKpL+cxUvtFDjCcM5w8h54kVSEwgxSu4bZBasGplzTTfN5AVydumsg==
Received: from LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:215::9)
 by CWXP265MB5155.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:194::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.11; Thu, 4 May
 2023 14:38:28 +0000
Received: from LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM
 ([fe80::cfcd:567e:73e5:b9ad]) by LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM
 ([fe80::cfcd:567e:73e5:b9ad%3]) with mapi id 15.20.6387.011; Thu, 4 May 2023
 14:38:28 +0000
From:   Benard Bsc <benard_bsc@outlook.com>
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: Bcache btree cache size bug
Thread-Topic: Bcache btree cache size bug
Thread-Index: AQHZPIE4AEjXVk/ajUS84UGmXeNcaK7GyCUAgAE4NQCAgq3IsA==
Date:   Thu, 4 May 2023 14:38:28 +0000
Message-ID: <LO0P265MB457433BA5B3E01C555CAAC75EF6D9@LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM>
References: <LO0P265MB45742A9C654C2EB4EB3775CEEFD99@LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM>
         <CAHykVA5ADwoio5Bhz3wLniufFNrOtT_fA4QR+DFr1EqbN2WpOA@mail.gmail.com>
 <LO0P265MB45748D7C230EF69DAF91D17FEFDE9@LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM>
In-Reply-To: <LO0P265MB45748D7C230EF69DAF91D17FEFDE9@LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-tmn:  [QYbqnUT/BmNL9J4X8dg3DLD8iZohSK/1Xb5n1GKkfmSqVXSoFm/Ab5PjsLvpdyiht12Ac9RwMD0=]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LO0P265MB4574:EE_|CWXP265MB5155:EE_
x-ms-office365-filtering-correlation-id: 6801ae0d-2ad9-418d-2455-08db4cad39c8
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /PjHMxwxxt8zJrKTA22UBgJ7Wy1gKPFgreqbQm/zfM3glqLH+P0UzVfQfNQsyGjPmbiwN3kPZbBs56l0jSp8R7SJWOWSsoHp300Y+fTXpL5+Dhqk0WBYuBb940BLIPOWDWKOXhYEEtgWuTRsvlTYgyUuHazVpJ7coBGpUru9ypXf9lhPbPFkKIktGv2HeRccnbUj1hjpTPm19oAOaKU+7TQuY1wP/dMcmSzspHERS/c0XKNbHOUaOhSvd57Ym4Ws20eRsLRLGsvhL7brAjZ8KezBCn2tqN1G8MEY2dxcJ0E+7c7te72Irj35aqoICaMMzjWWblJ030zymGB2COOYmVldmYFiiBZg2ZLK3II7gsQQYD72HIkJSuy4p75s/GYJ0ADp4SYr1VprUTtrpRD9NcPEhKdfzUH19T6LqufCZ9ZcPRhY5IECulm6LhdItcsfIDQ34zBGF+QasPGFJNTXAERqqfE6jUJrd3YRKJ+wL0IcAO0MmS1s4BtN3jfVs7qDF9O33ArA5Ea6sJ3YRo3b/3DokfzjQBdOxWmFBcKS5LHVrtVTamRpauDiTGF22jqzOJVgL9hUzxbtquOQO/zOZXJHe5bDRgPmnG83pegx4/zRKySSr+Ow1zzaEdr7vge2
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?+EhxVk+RdtGB4KLB4hP5zvYNvjt2K2ldUjIdqQt0+uw/d1Vm7PDg9KI/qZ?=
 =?iso-8859-1?Q?QeJQ3ZmIoyuwYVI9tSbI9g0FPGtMHAt6t56fRO1XQFe+YulMwV5StJW0xt?=
 =?iso-8859-1?Q?3pUAx6nn1kOIIAL2hvbBuLYyZTrH9Rq7rbJF/qQzIqLqs5gyUigcQolEBr?=
 =?iso-8859-1?Q?u/zMeBbhlQJzJ8FVwbba+7v0oTplXm0bJFpRHuCHGtc1quhu/d5s8yN3GE?=
 =?iso-8859-1?Q?FZO1bdEL6v5yDap+TVimlmUoh7o4CDITHXFQ9BVOUjAghBMmX8O5TBp3IT?=
 =?iso-8859-1?Q?rEPuZbQm2gH9s8W5rMFB59VIzvlVR4PzYI4hiq1TvR9C7cSyXXcE7Vz5aU?=
 =?iso-8859-1?Q?JEl22aHZ5JWWUVMPbp7SyrS/1JawnlGbciWM4/GNavN0ku+OkiouBljRp1?=
 =?iso-8859-1?Q?Y+1U7pEr/gxkEbqkwa7fOwXshQsjafT9a6W2MmQ8qUNUOZssh89ukx10Si?=
 =?iso-8859-1?Q?Y4B18kxqCLedUemRvhME28YQdHOgs7r7GW393Q98E6+YQU/9/fFHGGWIE9?=
 =?iso-8859-1?Q?Ron9fnUovLXki4KAQJl+2HHQ2B+PrrA2qLnay7gOZSpzpNYmyPfFMGzyB8?=
 =?iso-8859-1?Q?ylSORldIOI341A2Z0B1GYAd0/boJvVwBob6P751NldS+HadsWh9a3MadAf?=
 =?iso-8859-1?Q?aOvkV443C42clRyKTU3WgSwvg+5oMmpibTleY/phhM3gKAzpJD/n3Kd14w?=
 =?iso-8859-1?Q?Pk4lUiWHqg+2WLuYhsx1ODAf093+kW5xVvVEYwBMUlB1lKdPJdOeKt0Ngt?=
 =?iso-8859-1?Q?exMb5DXiLSiAxl2XawhF24/3bq8h9TKNwGQ+7+lbGLqJxjklbm/A3TTq/o?=
 =?iso-8859-1?Q?lfXeE3pBCleVjp30k6bAPLrOyIRKKccRBKZXOGjI6fmXokBCwo8r1X6sCr?=
 =?iso-8859-1?Q?5fpvL78584Ls4ck8iO2PE9crd++SazNgNO9FtJu1yW7jUnBX07G1t7BCbN?=
 =?iso-8859-1?Q?jvBjGkIloBewI0P4ERJ16zSyMNCNiW6b1HRzrAKRHr/+F4wT0m2gD15Bc3?=
 =?iso-8859-1?Q?Ln8AkjRg8ZDLykNZ9zsl5mNYtqTgtwnlnJOakCCGCbdJjHjJiaZrIs+Zx0?=
 =?iso-8859-1?Q?IrLHKgcj2fsOByX58WGPjvkwPsI6PxICz2eGUMTaQOqW3kJnjfMt1E3FJH?=
 =?iso-8859-1?Q?lX4t0y+hcSN5I4FB6zj2+AQAtPViSndE8Xw6ZilmxaZQUl8l8+qM4KcHmi?=
 =?iso-8859-1?Q?tXsfrIdZHQWoD6NFDvMLqZxR9fN9XTaO2j1uXt4fbl7nL63+5Zj8dE23bP?=
 =?iso-8859-1?Q?FATpbEtzbwnguQM5Tcv5nBI6xZdS27xs8ghaS9qQK7ylyeZpECyJHKaeTE?=
 =?iso-8859-1?Q?V9L8x9nRBVKUTCDLONYc2Eg5gQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 6801ae0d-2ad9-418d-2455-08db4cad39c8
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2023 14:38:28.5186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB5155
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

I've tried to upgrade the system to the latest kernel available: 5.4.0-139 =
and I have attempted to swap out the raid controller in case it was faulty =
but none of those things have helped the situation. Once again even within =
the same deployment 2 nodes are experiencing this problem but another one i=
s fine, despite the fact that they all seem to be the same.=0A=
=0A=
Is there anything else that can be checked/done besides upgrading the distr=
o? Since this is a HWE kernel I was under the impression that it should be =
supported until 2028. Are there any hidden configuration parameters which c=
ould have perhaps caused this issue? =0A=
=0A=
Regards=0A=
=0A=
Benard=0A=
=0A=
=0A=
From: Benard Bsc <benard_bsc@outlook.com>=0A=
Sent: 10 February 2023 10:44=0A=
To: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>=0A=
Cc: linux-bcache@vger.kernel.org <linux-bcache@vger.kernel.org>=0A=
Subject: Re: Bcache btree cache size bug =0A=
=A0=0A=
On Thu, 2023-02-09 at 17:07 +0100, Andrea Tomassetti wrote:=0A=
> On Thu, Feb 9, 2023 at 1:22 PM <benard_bsc@outlook.com> wrote:=0A=
> > I believe I have found a bug in bcache where the btree grows out of=0A=
> > control and makes operations like garbage collection take a very=0A=
> > large=0A=
> > amount of time affecting client IO. I can see periodic periods=0A=
> > where=0A=
> > bcache devices stop responding to client IO and the cache device=0A=
> > starts=0A=
> > doing a lage amount of reads. In order to test the above I=0A=
> > triggered gc=0A=
> > manually using 'echo 1 > trigger_gc' and observing the cache set.=0A=
> > Once=0A=
> > again a large amount of reads start happening on the cache device=0A=
> > and=0A=
> > all the bcache devices of that cache set stop responding. I believe=0A=
> > this is becouse gc blocks all client IO while its happening (might=0A=
> > be=0A=
> > wrong). Checking the stats I can see that the=0A=
> > 'btree_gc_average_duration_ms'=A0 is almost 2 minutes=0A=
> > (btree_gc_average_duration_ms) which seems excessively large to me.=0A=
> > Furthermore doing something like checking bset_tree_stats will just=0A=
> > hang and cause a similar performance impact.=0A=
> > =0A=
> > An interesting thing to note is that after garbage collection the=0A=
> > number of btree nodes is lower but the btree cache actually grows=0A=
> > in=0A=
> > size.=0A=
> > =0A=
> > Example:=0A=
> > /sys/fs/bcache/c_set# cat btree_cache_size=0A=
> > 5.2G=0A=
> > /sys/fs/bcache/c_set# cat internal/btree_nodes=0A=
> > 28318=0A=
> > /sys/fs/bcache/c_set# cat average_key_size=0A=
> > 25.2k=0A=
> > =0A=
> > Just for reference I have a similar environment (which is busier=0A=
> > and=0A=
> > has more data stored) which doesnt experience this issue and the=0A=
> > numbers for the above are:=0A=
> > /sys/fs/bcache/c_set# cat btree_cache_size=0A=
> > 840.5M=0A=
> > /sys/fs/bcache/c_set# cat internal/btree_nodes=0A=
> > 3827=0A=
> > /sys/fs/bcache/c_set# cat average_key_size=0A=
> > 88.3k=0A=
> > =0A=
> > Kernel version: 5.4.0-122-generic=0A=
> > OS version: Ubuntu 18.04.6 LTS=0A=
> Hi Bernard,=0A=
> your linux distro and kernel version are quite old. There are good=0A=
> chances that things got fixed in the meanwhile. Would it be possible=0A=
> for you to try to reproduce your bug with a newer kernel?=0A=
> =0A=
> Regards,=0A=
> Andrea=0A=
> > bcache-tools package: 1.0.8-2ubuntu0.18.04.1=0A=
> > =0A=
> > I am able to provide more info if needed=0A=
> > Regards=0A=
> > =0A=
Hi Andrea,=0A=
=0A=
Thank you very much for your email. Unfortunately due to the nature of=0A=
this system and the other software running on it I am unable to upgrade=0A=
the kernel/distro at the moment. I am also unsure that I will be able=0A=
to reproduce this bug as even on other deployments with the same=0A=
version of bcache/kernel this problem does not seem to be happening. Is=0A=
there some information I can gather from the existing environment=0A=
without changing the software versions?=0A=
=0A=
Regards,=0A=
=0A=
Benard=0A=

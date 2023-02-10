Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19B5691D19
	for <lists+linux-bcache@lfdr.de>; Fri, 10 Feb 2023 11:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbjBJKow (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 10 Feb 2023 05:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjBJKot (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 10 Feb 2023 05:44:49 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01olkn2070.outbound.protection.outlook.com [40.92.66.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FF06ADDF
        for <linux-bcache@vger.kernel.org>; Fri, 10 Feb 2023 02:44:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcnNZV+OPO9pjgU/KDs60OJM0wb8+NziUnrktuQ3ptN40m4+gcKFN5DsbQQ9egme548FaHjZPhbgAQObh7ycUEWvR8zjc/oE7C4Wu7iAQcZmHx16kIckEQNfAgAAMxweXsQqcgXuHVy09+YKGxyH/4tTEwfrPNdXyLjDouAEvkUKguDJa3TtEH0JR7ceckAm+K0KMpHfoMVfaN0r4+pxb3IIhq0xtbJ/ADbAW6f6BrVlA1Pu6JkGOLJi1UKHK1WiPDrWDzRfw56zyh00veQ5cB5MZ7uxjGHCnQ7QPRW6F4SPlqI9Z+v+1XrVzTONitazwD2F+GcS21Zsq/kZUWkS0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bHCCdjKuBBrHRI4jGXzQemTp/kT8BxjIOxmanScBfYE=;
 b=bqGj52BlJ9APifEashOVCHIuuVyoZj/fSlAEdsdnlb+WrxCmB2KUT3o7SPpltpEsijo6VWjo8pwQMTcEEThr5ZAN8lwEU4MC/2sHNkKhy8730TnDCqlzNQ1XmEWkqxC9TZH2EYKHpgCfb+j4czPoonZRwLew95k446YB+d8cXn1N2Ukw2nwuHh+3DnGpb+P8O+s5gnXu6PeXACzyIMtgwzT4IiC7Owds8EuRjpCTFB5AHRfABb5GURJiQFudR7lXQ/k85eWwMDz5bB5meRfRi7Gg+DSSx7T01dhh6Oq4f7jxGEJu79BQrSpxWAqMSKUKr3IlfAgBPOZzof07uEGwrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bHCCdjKuBBrHRI4jGXzQemTp/kT8BxjIOxmanScBfYE=;
 b=GZMe1wYN8gWV+eXgg8vlM5yv8koPFLDrMBSxwTdwDkvR1ebn4zKkPb39mYNfdcwLrHu6qS75167kiaiut0VaD6VeqBOqEfsYC+OsjN/2gEtOVXzsmJJ0NOAYXGor7D+EuEyyekzVE9EexBR8fNESos4rOCcoNbb/X49ubJivx7XQibkSJSDgj3gyt7miZ+TrSBN7pRt908J71yyhxqrrdTsoqZWwi0FUaFbEntgf2sHOFh9VW+8pARbKeGDDwCkS950IU9449mYcEKWE+Gqj9w5m2ompQKf4rWxupNNg9yuJ98M/tIiuBgu3pqBeUEkm5p/ZkfCi0VpqcmOFhhmeRQ==
Received: from LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:215::9)
 by CWLP265MB5956.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1ce::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 10:44:45 +0000
Received: from LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM
 ([fe80::66e5:1d7b:4cfa:1279]) by LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM
 ([fe80::66e5:1d7b:4cfa:1279%8]) with mapi id 15.20.6086.018; Fri, 10 Feb 2023
 10:44:45 +0000
Message-ID: <LO0P265MB45748D7C230EF69DAF91D17FEFDE9@LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM>
Subject: Re: Bcache btree cache size bug
From:   benard_bsc@outlook.com
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Cc:     linux-bcache@vger.kernel.org
Date:   Fri, 10 Feb 2023 10:44:42 +0000
In-Reply-To: <CAHykVA5ADwoio5Bhz3wLniufFNrOtT_fA4QR+DFr1EqbN2WpOA@mail.gmail.com>
References: <LO0P265MB45742A9C654C2EB4EB3775CEEFD99@LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM>
         <CAHykVA5ADwoio5Bhz3wLniufFNrOtT_fA4QR+DFr1EqbN2WpOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-TMN:  [k2h2K1qsBE3x60cMztC7lCTfpTKIaxcdMi9v3xYubkfWBI1CNUjVESoVkWApVjLF]
X-ClientProxiedBy: LO2P265CA0396.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::24) To LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:215::9)
X-Microsoft-Original-Message-ID: <157c5ab46e90676d88d49111215542336f5368db.camel@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO0P265MB4574:EE_|CWLP265MB5956:EE_
X-MS-Office365-Filtering-Correlation-Id: 20e57a24-0488-4b7d-f072-08db0b53d31b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FiKrjdB+HMHdIoYhqcTiPy0K0tVjRjw6MNx2LPbWQUQrlLIM0T86wkltWT5FCvsSXxHpSjeoDU3yk8mqKukmI2H5xg56OISrWXIgUZxdldKLuCAKtvg8Q6R2nffLtPZwz1Tfn5Enj8kfI0M4XKlk2SSLXPyBKC2l1d6ffYRyqMohCle553jrnWrcOqfgBQ31Ab4z3yOgpHyS9ts6kqG6414hW+4ENK7yFm5GjvTDD6WonOPA+2enaCyaxpo9+jbWstz+Z5TYRNdDmT6SoI4WyIfm7k2h5psmjXeXWWoFkSFklVwV9ff+9VRCXu2OrLocf4cJIDSD+rDPtMzK1+DNSLvfc6GA1DE4BLSKFjIC+FRX0wQWnKBTNCDXu6bTbhixaIZY3qExFheNH7c/dbWTooVm/UnMUl+KjEJnYb/If4Krb2skesqboWjpblEZ5OU5g6YiIlk80XqixG3nGDT3KZ5M5vz2xRJz7e60VfHyGvW190fyt3XB58+tccIrYXppeEAOakBAsRd8R7mgloYh6nBY8QBBVho/2PjIkt52AsoG9zpjuKBGfAcPFYKK8OyGJthL5PoJ4NAsrNqsvCAfNvwvUgKT0MiTOFsg7/XIzrY+wvLnSrNFt1dcHJAKtMcRWJxCU26w6Swx9JAjJLwnfVu+vFgBd69xx2EuSILAA24=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVR3cTBOV3NNVnF6ZFBOVmF2b1k0WVprVDFmZFhWL28zSmt4b29vNmNBbGgy?=
 =?utf-8?B?dkRFbFNSOFcwbUVDUEl0bTk5VCtPM2Z3MFFibVBGMTBaZUVHNkRWQ3JWaDZZ?=
 =?utf-8?B?czhYQkhVeFRyMm15WFhKZkNuTFpXNyt0RkpnaXhIOC9aMlNoWjN6K2xqRjhO?=
 =?utf-8?B?Q0x5Slo2U3Z0UTErb1U2MFQxQ3RRWmhMaDRySWVtZlNudDQ0U0t3dUdFcFBK?=
 =?utf-8?B?ekt5V1FPZTZmWTFPbVFkT1lPQUZCeEI2VVc0cnd3RnlzdlczK1Y4OWM5ZlB1?=
 =?utf-8?B?cTFXQnNaVjV0cmRhNTJRRkc4MUE0SWZtWDA4b2Z5Z2JxVHhwRkc0WmNycGgr?=
 =?utf-8?B?Zkc5OFFPUzMzVkU1WkpSbndNak1PVUd2ZExqY1FtU1lyTXI2TGp4YW01SW5U?=
 =?utf-8?B?dm85RzZ1SzN3NklPcWFMR3NQOFkxSmh2c2xtT05QY0ZUZXYzYndEb0grcGd3?=
 =?utf-8?B?bUJjZ3JNWVlOUExtTG1VVy9QWDVpSE9YbE1PY2pIU013TWpyMUU4ZEdsb0RE?=
 =?utf-8?B?YnRSeXhGY1ZDV2ZZcjBybmxNdGZLbjFVNWNQYndUYnNNSnlWbVdGSW5lQ3Np?=
 =?utf-8?B?QndjNklTRDRKNUd1SWl1aDlvNHhOMkFHVXpsV05FaE9UUzJ4elo1U3lWUkFj?=
 =?utf-8?B?VWxJVnlzUEJoNTB1ekJrQ1k0Q3lWM09GTkdtZnd1SmF5dUk5bURCNkpHYzlx?=
 =?utf-8?B?RTRRMWhNRTVEZ0prRjU5WFFnUENoSFRlckMvM0hHdlhTazByZkRiUXVJZ0xC?=
 =?utf-8?B?TkIxOURNaGp1VlZRYU1TeUJKdmhJUW0yamJ5VExlWThqUUVONm5UL0k4OWNu?=
 =?utf-8?B?UmVvbEdYVjBEZHJXa2F3TjdvcFRxbVZNR1VsSlNFZzVaQWtmaUdkNW5wZk5O?=
 =?utf-8?B?UU43c2FYcG92cVVVNEIybktSei93T3JXa1A0S2pUY0Zab0x0cUVsZFZ3a0JW?=
 =?utf-8?B?NjlJdmRSWE1EYXhZemhxeXR4RzhnNWc3NUwxWGVmYmdLMXpzRW1OdHFKL3Vp?=
 =?utf-8?B?a2R2R1NVVnFOS0RjMVZUZSt2OUlwTEVUd1BqV3g3SkhucjBqcjJmYXFOUThE?=
 =?utf-8?B?Y25udno4TThjTTdaRVpqSVJIalJmVVV4dzU5UElVV1ovZXhqbStLZ2ozZ1Bo?=
 =?utf-8?B?Rm9tWkhPalpEanh2U3Y2ZzZpdFpDY05neDB1ZXJ5SDBPVUgwRHVpb2NQT1cx?=
 =?utf-8?B?OE1mMTVxWE9od3dtVzFuWWlscmFlaFBSSEF4aFJpU2JUQVNHcTJrSjZHbEQ5?=
 =?utf-8?B?RXhDNk11bW0rTDV0bGhDYml1SkM4dTBVc2Z6ZWFMRWplZXFpRWo0Z2tBcy9W?=
 =?utf-8?B?bnRPdzVhckhTTGxUdEFGVHYrMklRcVhSL3laendISXRELzNUNVFrNTdZaWhX?=
 =?utf-8?B?NjlVdjZtY0ZGYW0xMmtLMlg3em9LOGdadmpnNWIwMlpMWnlkYitiNXFJVGtu?=
 =?utf-8?B?b0g2ZUdBUWhBaEUvcHdVcElNdmZKZjhWU29RNFVTRmlZTFVOSWtHckpDY0lr?=
 =?utf-8?B?OXk0dkprK2tFRmU5NGhITHVHbWJYaVp6QmRXWFAwaWtkTkhoZ3U2WktLYWZm?=
 =?utf-8?B?c2NTUG5NcUd4WW5NTEtsQUJ3SXhMNzZ3cEcxQi82eE1JUGdjdVVoSmNTT2Jm?=
 =?utf-8?B?a0grWmVKZzJLcXk4TFpwVVBTeGJ3ZU9FOXp1VnhCQ2QzSmhEVjJVcE5vTjRy?=
 =?utf-8?B?WHpoaXc1UGx5MHk2OGRrYVJQcjRZV2FQVTgzQmJ4Y2FnclErbDRmNXV6NUNl?=
 =?utf-8?B?c2hlU2Yrd0JIejN2VzlPaTFNZTdYSzRiWmduUGFoT1lxTEU3aG5FRFAydGV5?=
 =?utf-8?B?S3dtRjhiV2Z4SHRhQ1F2UT09?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20e57a24-0488-4b7d-f072-08db0b53d31b
X-MS-Exchange-CrossTenant-AuthSource: LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 10:44:45.7415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB5956
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, 2023-02-09 at 17:07 +0100, Andrea Tomassetti wrote:
> On Thu, Feb 9, 2023 at 1:22 PM <benard_bsc@outlook.com> wrote:
> > I believe I have found a bug in bcache where the btree grows out of
> > control and makes operations like garbage collection take a very
> > large
> > amount of time affecting client IO. I can see periodic periods
> > where
> > bcache devices stop responding to client IO and the cache device
> > starts
> > doing a lage amount of reads. In order to test the above I
> > triggered gc
> > manually using 'echo 1 > trigger_gc' and observing the cache set.
> > Once
> > again a large amount of reads start happening on the cache device
> > and
> > all the bcache devices of that cache set stop responding. I believe
> > this is becouse gc blocks all client IO while its happening (might
> > be
> > wrong). Checking the stats I can see that the
> > 'btree_gc_average_duration_ms'  is almost 2 minutes
> > (btree_gc_average_duration_ms) which seems excessively large to me.
> > Furthermore doing something like checking bset_tree_stats will just
> > hang and cause a similar performance impact.
> > 
> > An interesting thing to note is that after garbage collection the
> > number of btree nodes is lower but the btree cache actually grows
> > in
> > size.
> > 
> > Example:
> > /sys/fs/bcache/c_set# cat btree_cache_size
> > 5.2G
> > /sys/fs/bcache/c_set# cat internal/btree_nodes
> > 28318
> > /sys/fs/bcache/c_set# cat average_key_size
> > 25.2k
> > 
> > Just for reference I have a similar environment (which is busier
> > and
> > has more data stored) which doesnt experience this issue and the
> > numbers for the above are:
> > /sys/fs/bcache/c_set# cat btree_cache_size
> > 840.5M
> > /sys/fs/bcache/c_set# cat internal/btree_nodes
> > 3827
> > /sys/fs/bcache/c_set# cat average_key_size
> > 88.3k
> > 
> > Kernel version: 5.4.0-122-generic
> > OS version: Ubuntu 18.04.6 LTS
> Hi Bernard,
> your linux distro and kernel version are quite old. There are good
> chances that things got fixed in the meanwhile. Would it be possible
> for you to try to reproduce your bug with a newer kernel?
> 
> Regards,
> Andrea
> > bcache-tools package: 1.0.8-2ubuntu0.18.04.1
> > 
> > I am able to provide more info if needed
> > Regards
> > 
Hi Andrea,

Thank you very much for your email. Unfortunately due to the nature of
this system and the other software running on it I am unable to upgrade
the kernel/distro at the moment. I am also unsure that I will be able
to reproduce this bug as even on other deployments with the same
version of bcache/kernel this problem does not seem to be happening. Is
there some information I can gather from the existing environment
without changing the software versions?

Regards,

Benard


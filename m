Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6293D690895
	for <lists+linux-bcache@lfdr.de>; Thu,  9 Feb 2023 13:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjBIMWw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 9 Feb 2023 07:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBIMWw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 9 Feb 2023 07:22:52 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05olkn2019.outbound.protection.outlook.com [40.92.90.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4DF1EBD4
        for <linux-bcache@vger.kernel.org>; Thu,  9 Feb 2023 04:22:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiTjtG3bGDQlOdbGzTnUxtEgNO07NADdRkV5VU3wd/JCFJK1+/x6FMzLPz2oQVqNDSdxUn4qC6J/WEMDBZar5UoiZALDwwEYlpae0GWCyWgGlG5qo/DkH9Aq/kAX9VaVkA385jHvdmUtzTkbevbJIJHBzC0NI/KbRjrwkM8R2RznPW+wyceyBd00vEhEPxZMsY4PDZeoaQui6AitQTdfaQVLgW6D5uO+CaD8JZDNfQIP9UwZY6lVwzPk6AaGmzChwYmGDOO2QZRqN0jqzNE1qVqsTPdVFJdLNz+m5LYyrcGoicQG2kip+ladNnT0OnF1iXWXH+Va3JyzrNwbt7p20g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4+8Af/Aumhmq+Cd3wNtxbWmU+1/ujv6zGUKSBy/mqTU=;
 b=TMrk4xj3NnbFKC+Tf+3w+/RilxgkSYvJy1uychRkh4ufya3VYdLKS/knCN4F6OmqOIlHUYq4i3VC9aApjm+2LBljnJRw+suV4DL5bV3cexbRpZd0lIMV5fZHkj8l4nBNpslFbRIoe2J9d4DPN5ENtWqNDLvQC0MvdY7rLx8pbMgOSCy0l3iEowJQ42GdM/Zh3nn3hl+VaLAizyaN+tu7+VD2lKYeeDPS/Mh3bF4S4A/tzzBhInq/eyhNFOYdFtmlVdm1TLaQ7XiYOQYzGP0yJvNO2Q1re/HV9Q9t7QVi0XdcFe5A+J7CxHPY9sfK5mAgt44dNnY8Vub3VkcWyBEnkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+8Af/Aumhmq+Cd3wNtxbWmU+1/ujv6zGUKSBy/mqTU=;
 b=MaZEVfdyYWFeoNKeFrWhgKf71rRoAv8udJ5sXzbYn2dI354mkmXMoP97wleaeWnfhqdz7PVTjwr+K7ukbi8I97bkCyNN+HVxsVa8NF1TN0Y006jOy0XlyIUq5C8qr4i8gezxIEi114Rxo+pUcvDseKxW05FypYYBq+6pAirZZjEIdLtfHE5M3wQXP1SBB9nNs4imn3Wh55AiBQjWi1Jot0KzfDLK4JcIR1yoRMJjlTaEJkNyCbgT8gwKoNtmGXjHFVZ1/TCSqTIDEGPYdTCpCnzngqsRKe+EodYkiBIbuTwdmcsY6FRVpQpwsjIdZZOKVwnuhcE4kUQxvnNYLuqYIw==
Received: from LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:215::9)
 by CWLP265MB6880.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1fd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.18; Thu, 9 Feb
 2023 12:22:48 +0000
Received: from LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM
 ([fe80::66e5:1d7b:4cfa:1279]) by LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM
 ([fe80::66e5:1d7b:4cfa:1279%8]) with mapi id 15.20.6086.018; Thu, 9 Feb 2023
 12:22:48 +0000
Message-ID: <LO0P265MB45742A9C654C2EB4EB3775CEEFD99@LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM>
Subject: Bcache btree cache size bug
From:   benard_bsc@outlook.com
To:     linux-bcache@vger.kernel.org
Date:   Thu, 09 Feb 2023 12:22:47 +0000
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-TMN:  [Xyij5eM624Izc6+90b0+BYs1ujuXAqWfi26dt8CS5kb8MIbmQ/yYDrFazN2OC2GoiEsXWYlba6c=]
X-ClientProxiedBy: LO2P265CA0227.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::23) To LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:215::9)
X-Microsoft-Original-Message-ID: <ec25d7bf9df137e8f5771c7dc7f5299f6081e2cd.camel@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO0P265MB4574:EE_|CWLP265MB6880:EE_
X-MS-Office365-Filtering-Correlation-Id: dabab5ed-cd72-4dce-b810-08db0a985aea
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r4usFKHBq3ycR0voV9gEGaS3iO3k7dg5aHEm93G/53xpTcIkfRMiGrPwUOprh36J7R5S/ew68WYwV00GQhKTYcvlSyGn1dtxgVZ7qI5CSqasBYBql+ezC4L6XhPQFj8weqlR7Bp2bUbDZjDvBbYW3rZSNGsToaacQG4+i80ja72sKcHkqiO4FHhpk3EwBQL83yH/iqV+2P430iEGO1tAeps25GPpvqmqD6CvKmpVbKkIyHLSWXNmm6gIGwEz/WXdqyJ6tdHyeiPHFG4C446sFZ1F8ANLf4fu6OoVYfAq1eiuGmvC1OijqOKoCapoH1GdRCSSMewFkKL/WOdjkmRsQOrwu8MU6LkJkZ8u4teor722ErbMkZuraIXMpbaxnHAg+XVX3jm3qOCIF2yIRvWp2bF0avHIS8EQEPEcV1f1kMqiguqMSPuvsUF1+SqOe27hSsshFcLJiudHJMzYvPj2NlJ21qWKsfcCFbyK7TNuWFoaDVqoOn/yiPXZ6MMlLUuQaOTOzgIu+5OoSZncZejV5LeZFWxgZxBnM5Nnj9qHCQDBX3F5B7ncxbrhSM3zsjCUq91DJkq+RbnVUswt8xFbWPLDc4bO1zr9cj/AhdOAYoE=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2gyVXRER1k3aW4zYUZzekxwRUZvamEyRVhHREhWbHVPMGIyOE5oMmJBb0FI?=
 =?utf-8?B?RVdkZWRWVUMrNXhPZFdWT3hzR0FCUzVaWVpKUTFFaW9nd0g5RFBGdDdqRnI3?=
 =?utf-8?B?NjdEOFR6SFBCL2dMRCtaMEtoOVQrSldqZmwrMHhKRmd6cHlBQk9MNVFmYmVM?=
 =?utf-8?B?YjQwMXRsTTNZbnl3ZExudkJxZ0RIdHdXODY1YlVUcldrNjhyT25Edk5aWHgz?=
 =?utf-8?B?U3A5YVE4aUYvKzFudFA1eVlKaXhMWVN2VElLYTJ0Qjk1cnBnWnRSL1MrcnRa?=
 =?utf-8?B?VnM5amlHZnpUZHVzSFRSUzA5emRsRFlZKzA3NTZIVE5NaUo5a1A5ZVp3ZlR0?=
 =?utf-8?B?TVE3MlRpSjQrNlNFK0VGdXBWdUFXSCsycmxCcGovQlc0UHVxTVR2azNhNVVI?=
 =?utf-8?B?TEh5UUtRZE50SlBxSE9GTmkybDg0a3h3OExjL1hrK012YUlRSnc4WXprWTV4?=
 =?utf-8?B?MlpFZTN5aGZJZGNyVW1wZVJMbnlHeWdCengwcWxFOGJNNGVSM0wybVF0Nk1M?=
 =?utf-8?B?clBBTzBRRWg2Zmc1dWhFb1JHdjlGSDVuamN6MUF4RkJDa29MMW1CQllrcXIx?=
 =?utf-8?B?MUpRaE1jaDFzREJ5U0VwR3g5M05YanNEc3NNa2pPQk5FZXAxc0xUY1U2d2xJ?=
 =?utf-8?B?YXNEbSsyK0RCa3loMGszWTRoeHNtbHIrN0NlckQ4WGFZZWVBN2lqcS9KQ1A0?=
 =?utf-8?B?bEdZWi9qU09uU3BrdGdCbGdNUnQ4SC9JbHhLaURpOXVEWm1xWjB4ZjhRRFRw?=
 =?utf-8?B?NE5ZUWdQdUtCRVczSndNT0VWeGVXZlRJeENYTUZJVko3dzM4ZVMvK3BML1pP?=
 =?utf-8?B?YzNUZXIrQzRKaWE4Uy9hUFdHL0cxc3g5UlJTSVdleXlEZGRYTHVGa1JsY09m?=
 =?utf-8?B?YmVZVSsva1FISDNRN0hXbWNleVpoRUduVnIrMm9hN3orYU9NckR6OUJobEdS?=
 =?utf-8?B?T0lDaC9rOFlpQThrak9hYmZGbm5PQWpvZjhpYU1IZEM2YkhMS0s4YmI4eVlP?=
 =?utf-8?B?SE92aVh3NGNiQ0dwdjRKaXBScjhwZTFYMm5mR1kwcDd0ZUh5T2NMM2VkYnVh?=
 =?utf-8?B?azhoZldHcHE1M1hjVEJ6aFljUFZ0UTlsVlRLYWZySVJmcTBja3hFYTVPK2xO?=
 =?utf-8?B?c1cvMHNYRVlIMGQ0bUx4MFBRNXpTQk12Q0wwd3czdzdsY1Brc3R1dlFabzBI?=
 =?utf-8?B?NHkvdnM2U3N4STVidFJtNmlTVXM2c3JzQUZYU3V2VUpPMWY2WnV0S3FQWVZD?=
 =?utf-8?B?YmFNQmd6TlpWcno0MnZxLzZzVWo4VXVZZ005WGtRSXcwcFdVUTNSZjQ5SExD?=
 =?utf-8?B?eUJsUGxhdHdKQ2kvUmlpd3lPbnB3ZklvbUpSVkZMR21ad0dXcnZlQWhtdjI4?=
 =?utf-8?B?RG1vdHJ0c21IUzRkbWM3aXNHMmxKNHVydytOeFZmV0NHSnhVdzg5Y25SRVV1?=
 =?utf-8?B?bnA4YnVSWTVDbFBkVWZWV3I3WStOYjJtcGhQeXUzUWxyWXFQZlBRS0ttSGR0?=
 =?utf-8?B?SFFaWEJKSGM0czNJdUMwbUhMc0dZdk0za1BpUWJqcFY4dE9Mb3FYTDhxVi90?=
 =?utf-8?B?Y2dObHBUK0g1Rm5sejhqVnU2VDVLbHBaMG9wY3pFb1QyVDc4K0VnZHJKS0Rn?=
 =?utf-8?B?eG8zYTBGejd6VzU4UEQzYlFEampTRFh1ZCt3QXh5eTduU09PL1BSK3NEMmZh?=
 =?utf-8?B?QkRuTnpscUJBUU1HVjV2ZWhBaHN1SHdzQ2JDS1doMEFNUW1TVDZWdTRBN1d6?=
 =?utf-8?B?c2ZJbGloblRPNTJvTko4bXBLUndiOGFjU1NUaUFrRmdERytmSDdPemhYNlNm?=
 =?utf-8?Q?PFmjzwUZssMBFjpAJQoDYmCJJx0r8or3nCUDc=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dabab5ed-cd72-4dce-b810-08db0a985aea
X-MS-Exchange-CrossTenant-AuthSource: LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 12:22:48.5163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB6880
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

I believe I have found a bug in bcache where the btree grows out of
control and makes operations like garbage collection take a very large
amount of time affecting client IO. I can see periodic periods where
bcache devices stop responding to client IO and the cache device starts
doing a lage amount of reads. In order to test the above I triggered gc
manually using 'echo 1 > trigger_gc' and observing the cache set. Once
again a large amount of reads start happening on the cache device and
all the bcache devices of that cache set stop responding. I believe
this is becouse gc blocks all client IO while its happening (might be
wrong). Checking the stats I can see that the
'btree_gc_average_duration_ms'  is almost 2 minutes
(btree_gc_average_duration_ms) which seems excessively large to me.
Furthermore doing something like checking bset_tree_stats will just
hang and cause a similar performance impact. 

An interesting thing to note is that after garbage collection the
number of btree nodes is lower but the btree cache actually grows in
size.

Example:
/sys/fs/bcache/c_set# cat btree_cache_size 
5.2G
/sys/fs/bcache/c_set# cat internal/btree_nodes 
28318
/sys/fs/bcache/c_set# cat average_key_size 
25.2k

Just for reference I have a similar environment (which is busier and
has more data stored) which doesnt experience this issue and the
numbers for the above are:
/sys/fs/bcache/c_set# cat btree_cache_size 
840.5M
/sys/fs/bcache/c_set# cat internal/btree_nodes 
3827
/sys/fs/bcache/c_set# cat average_key_size 
88.3k

Kernel version: 5.4.0-122-generic
OS version: Ubuntu 18.04.6 LTS
bcache-tools package: 1.0.8-2ubuntu0.18.04.1

I am able to provide more info if needed
Regards


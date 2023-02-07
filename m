Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D552C68D5E5
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Feb 2023 12:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjBGLoC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 7 Feb 2023 06:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjBGLn7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Feb 2023 06:43:59 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01olkn2083.outbound.protection.outlook.com [40.92.64.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEBD2FCF2
        for <linux-bcache@vger.kernel.org>; Tue,  7 Feb 2023 03:43:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dl7GDQMPtpUN6x1R04PK06+ciGSRAMiJOcl0p6gDcItNZKML3bmlGK9vnLzHHNaC+Xx6J89uU6GKADZSRzHE8Td8uGsJQWJoc1HRjETttz7rYJwjueOnRd4bIdmjRdALM1xDthhjyKQpUrFoJnTk6oRTGlnT5PykpocZ4YW/Wwmf+BAVx/sUC7gKcFMQCrHZXg88ZYpFJ25eijBOBWXDOh0nomRiOBBt6JV1sBQCatXYEs7veD+bRx21KO9rb55TSc7HvWyU34Prxb23YxWU3Z976SFMZ98BnC+lpsXsUWQhDPvoDdCOg/mjFN5vIJDXlxah7dTu+3O2+UWi6n7nYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCe0NOnzC5ZeItkp9sLYRfnW/YpfikhussuBVU6EMEc=;
 b=XsYgKnGk3v1LMwjqX+KkithhIpT6aEN3ZxbQ8BPD2ehecM/tZl3f6rnrGN43OjZFip9r8L7VibEYgbOJDBw72+pQso0j/EESKHuhVb2GAKrXlXfdAvtTODel/zFzKAXFeYzZe23aJqqgktooEeNwtMv5Gg1jXZdbiyoGFxmD1pbnem0/tmd8UJbFtxwpGhrowA0t/nPzBRCp4dFHxA7P2uzr1o6agzozb4G+LYB3aw+8vHWdRQLDkCnOsxlFo9KJGxwSHQuQzM5PEdbA7usUmV9BDB95liNmvkJFoq6E87tmzSLT4sIxqbXLaBFGDEzWrc17spLIcGqs6lDCqyRctg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCe0NOnzC5ZeItkp9sLYRfnW/YpfikhussuBVU6EMEc=;
 b=KOFI+Y7O46AlyYI51+Y8R/dk6dR8Ujhzt8FKAdbx3pcpBpBAkeXQDtVpSzTygBC/GmCuGgw0Y1xp5C0g020MjlwaJZkgM4MBTNpBBH6XeNydtHb0BV+0C5w7C9o+LR9dJdG6y1ymLNTrnV0Kpu76NwTYEWQJwZAWk94eOkAGBbK6+1WS5nu2ydeLz/ktkOfeqFRMFirJ54u/XE4JxmlmJ3LhOnOehiLuFw96p/2ypksevs7mH5qGBLtyUcDtOrVrMf7J+M5yGXzPsU3fcepSbQZLSwMXBMAPnt+HcP7G3PTBQaJouiq0SW7bQcGsSnhLKqV5gIAJl4NSO1eD0U5Xdw==
Received: from LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:215::9)
 by LOYP265MB2320.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:117::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 11:43:53 +0000
Received: from LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM
 ([fe80::66e5:1d7b:4cfa:1279]) by LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM
 ([fe80::66e5:1d7b:4cfa:1279%8]) with mapi id 15.20.6064.036; Tue, 7 Feb 2023
 11:43:53 +0000
Message-ID: <LO0P265MB4574454029F1D6E0E6B5519AEFDB9@LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM>
Subject: Throttling performance due to backing device latency
From:   benard_bsc@outlook.com
To:     linux-bcache@vger.kernel.org
Date:   Tue, 07 Feb 2023 11:43:50 +0000
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-TMN:  [ZV+j2tFUa4yXFrQ/zMyyeJKZebHtMOFiIXDW1uMO2yfcgYjxQIPsFiZ/MrGejURugzzU76Ciifs=]
X-ClientProxiedBy: LO2P123CA0058.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::22) To LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:215::9)
X-Microsoft-Original-Message-ID: <5101fd0da4990efa4e57fe313a1174102a2fb5bf.camel@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO0P265MB4574:EE_|LOYP265MB2320:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d5491fd-0fa7-46ee-7072-08db0900966e
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1tmp6fgZ28cbVjsyNNJj3g0NXLn9Z8XmTXg8XZglqlqKziNoXFqy65So2UeLDg8OrQiADjPrPc2yIK4/nCzPvOzzq269Dl0t4h3B9hOXL5E2+qSmoxblJcq25GvvgLWVIS2SYa0MjbotlqosD6rPMkGnWgAp2R40afQl/UFjecaEekmNayXWs2cdZ7TV+aLgNLAj78dzJ8RDt4vlG9+jpbl/o/LixIfDGmvqYCslGRvDycUJEL0qIGqyWbwpB63syDOhfmdcVbYsc+GQv5oIserNhmrYBWxOvMwwPwj5IRub/hlAgCamTV9Xp7ARbO0KNZnV/rqc+Q95hRE+xV4GUw7wPMV/bRMjO4QE63rXzvN/K2AXV7nn9E2/dClUe9ELtlPm3E9lzsZVM1H8ubOhCYMPTJlLQbVsTck2NZ2pnl7XlcAwz0tyI04g2kO3QpanfpUaoqcEfKTLO5wwhPlEsBl/n1jty/OIN8pS3Rk+2UWceqYSl9Eax/sfvnt0qeDBYfrlEETP1ZcIk36siEgmoGI9TC/AVTOkBESIpmNXX56zaMskR5SirDtuqm/0q5p5E2MSxWi/n73N/FXnTtsFLljausiKHxBiJWo83hr5xZY=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUxkaFcyb09iU0Nwb1ZFanVscUFLZUJRa0JxN2FMRVlqY0hHaWRRSkJjc2ho?=
 =?utf-8?B?T21aOGk3NVNEMS9qaVdzcEhDUEpuMjB1Mkpic1dnTzZQZUJZNVB6bXJocXhh?=
 =?utf-8?B?QmxHK0dyUW1tVjhxU0pBcGtFbTdob1B3dHpESGY3TkdRYlc3V3A3NDRBTzc5?=
 =?utf-8?B?ajFhekJ1dGJpUGU0Zmo2RVpSZ3VCVFk0VEt2dTJ0MmMwOG9XZHlBOU4rRHVY?=
 =?utf-8?B?Qy9tSTErWVQ4YkpaRWhzU3B4ZjB1VlZRYUZQSnF1TmtOUHFBMVVwZk51eW1q?=
 =?utf-8?B?aTNNNlgvVm4wYU5ubGdVOXY1NkFLUG80cHg5cE9mS3RiejM5czFPc2hwV2NF?=
 =?utf-8?B?SGhNNHNrOC9rSU5RL0RCNE9URFhjb1VEQ2owM0kzcmhEV3Q3R3J0WWVKbVRx?=
 =?utf-8?B?OEVnR05pYjVaZkVPclJVQUNnUndwbGJQbCtiSnZyZlNGRFVoYW1JUm8yamlB?=
 =?utf-8?B?Z0NTTlpNMHFNMUV5Zzl3eFhMaGloNlRET3BzUG5DZWJzM3hraEpDWWJlaHNT?=
 =?utf-8?B?VWY4Z3ZUeFY2eXE0RlEvV1JZcFowM3VaZEh1RW80citCSjR4QTFDaldUT1pV?=
 =?utf-8?B?eTR3ckNFMEQ5bFp1UldSU2x1bUpRRzByTEJKU0NRcVRsNkJlRXZPWGgvZjl1?=
 =?utf-8?B?Y0xhd1RiWTFXZ0N6ZDlOR3pwTTBaZzhpVjdTZnU5VDhTQnNiamhNTHR6N08r?=
 =?utf-8?B?R2wvTnc5c21zNkJkU09veTZvZmhTRkwzeFpPK2owSGdRYzRlSnY3R3lCQzhN?=
 =?utf-8?B?aDRjYzlyeHI3MVc3RVpzV1hhL2pPQUNML2s3SXdoOVRuaFU1RWdiQjhWN0k0?=
 =?utf-8?B?UFdoMlg4U3JYVVR5MmVDeGppZWdFelF4bk1iY1U2MStTNW52MHBOTmFpeS9G?=
 =?utf-8?B?MUwrbnZwZCtGbGN5UjE0T0xMdUhCejVpbFVyTXBTV2x5eEZhZ3FURkIyWlNz?=
 =?utf-8?B?MWs0eXM2ZzBkVlp6ell3SFJoczhwOVVBNzkzeGpWWms4V2ZXQ2w0dGE4YVhq?=
 =?utf-8?B?SDg3UUgzaVpiS1hYdmtWbWI1SmdFUFVTRDE4S3FOQzlRdXNIRGxUTjkxbVp4?=
 =?utf-8?B?QVM3b3RxYVN0MENrNHNPbVJWdVJWSHJDcEo1VHBtMHU5NjlLYlZlSlZXUXJN?=
 =?utf-8?B?N0Y1QXM2Ri9tQVhNOXdEbVp6VHB5anAxeUp6Z2NiSFJOT1VtemNRVC94MUpl?=
 =?utf-8?B?UFEwTVZaRmNJOTNwRzRUR01jTnA1Q1h1L282R21lWDZYdU13MVJZQ1V4ZVUv?=
 =?utf-8?B?QlRZYWVIbzArYXBXMDlRb2I2NHBraG1weUFJanBjVkpRcnl2aDJub0hhWEpB?=
 =?utf-8?B?NTgvVGVwNk9ZVFdqWTY4YmRZTVpPVC9LQTVGUUN0cHRTSlQ0cUNyWEJKak1P?=
 =?utf-8?B?NG1jdkZ2eTJZeW91OTVFVXVRQ2ZwUDUwYno0RloxQ0VaMW5KcDJ4aEJmYncx?=
 =?utf-8?B?bkd6SUh0OXY5SDdOY1F4L3hvYU9hWUNtQ2RSMWlTeERMSjdHOWtyNHI1RGVM?=
 =?utf-8?B?MllYNGFOcHZrSENzWjJHVDNZRXVobzNDdnVHeDJCZG1DQjBPTFlvVkZITytB?=
 =?utf-8?B?WlVidUZZNFN1TWljbi8vZFBIMmFVZ0JUU05sazc0MS9BdXpSS1FlemVLRzlq?=
 =?utf-8?B?NHBLbDFkZi9kZ1poMkp5SElkTGhUMWR2OEpJUDBvR01qb2dvM1diQlg3M1Vv?=
 =?utf-8?B?QlRkNm1BNGd4b2x2eEVDVXpnc2lhQjAyM1ZCcytjcGZYVDFJRVRLWVlCcGhi?=
 =?utf-8?B?K09jN2Njek1temdhYktwQVk0TXdVVHpXQjhlWThNTjdMUUROYjF0VXhtdXdU?=
 =?utf-8?Q?4Io7Ik4VYplPIixohonj+BqdPa9vU76dpgS2c=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d5491fd-0fa7-46ee-7072-08db0900966e
X-MS-Exchange-CrossTenant-AuthSource: LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 11:43:53.3102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOYP265MB2320
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

I am currently using bcache in a configuration where 1 cache SSD is
caching IO for 3 backing HDDs. The cache mode is writeback and I have
configured bcache to disable seq cutoff and congestion tuning so all
write IO goes to the cache device:
echo writeback > /sys/block/bcache0/cache_mode
echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
echo 0 > /sys/fs/bcache/<cache set>/congested_read_threshold_us
echo 0 > /sys/fs/bcache/<cache set>/congested_write_threshold_us
 
I have increased the minimum writeback rate so that the available space
for the dirty data never goes to 100%
echo 16384 > /sys/block/bcache0/bcache/writeback_rate_minimum
 
 
I have noticed that during times of higher throughput the performance
of fsynced writes (and other high IOPs workloads as well) seems to
suffer a disproportionate amount. The throughput is something that the
ssd should be able to handle easily and it still has enough cache to
buffer any writes there so I am confused as to why performance would
suffer to such a high degree. Are there any internal mechanisms that
perhaps measure latency to the backing devices and then throttle IO? If
so how would I go about tuning those?
 
Regards,
 
Benard


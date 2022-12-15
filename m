Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A123964D70D
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Dec 2022 08:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiLOHN0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 15 Dec 2022 02:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiLOHMq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 15 Dec 2022 02:12:46 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E2E31373;
        Wed, 14 Dec 2022 23:11:08 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1p5iOY-0006Tn-Tc; Thu, 15 Dec 2022 08:11:06 +0100
Message-ID: <2e4e65a8-87b4-fac6-ef89-76b118b0cec4@leemhuis.info>
Date:   Thu, 15 Dec 2022 08:11:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: =?UTF-8?Q?Re=3a_=5bregression=5d_Bug=c2=a0216785_-_=22memcpy=3a_det?=
 =?UTF-8?Q?ected_field-spanning_write=2e=2e=2e=22_warnings_with_bcache_=23fo?=
 =?UTF-8?Q?rregzbot?=
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Cc:     linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <19200730-a3ba-6f4f-bb81-71339bdbbf73@leemhuis.info>
In-Reply-To: <19200730-a3ba-6f4f-bb81-71339bdbbf73@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1671088268;f375fb93;
X-HE-SMSGID: 1p5iOY-0006Tn-Tc
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

[Note: this mail contains only information for Linux kernel regression
tracking. Mails like these contain '#forregzbot' in the subject to make
then easy to spot and filter out. The author also tried to remove most
or all individuals from the list of recipients to spare them the hassle.]

On 08.12.22 15:53, Thorsten Leemhuis wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216785 :
> 
>>  Alexandre Pereira 2022-12-07 18:51:55 UTC
>>
>> Testing linux kernel 6.1-rc8, I have several kernel erros regarding bcache.
>>
>> For context, I have a bcache configuration that is working without issues on 6.0.x and previous versions.
>>
>> The errors:
>>
>> dez 07 18:33:45 stormtrooper kernel: ------------[ cut here ]------------
>> dez 07 18:33:45 stormtrooper kernel: memcpy: detected field-spanning write (size 264) of single field "&i->j" at drivers/md/bcache/journal.c:152 (size 240)

#regzbot inconclusive: stop tracking field-spanning write warnings, they
come from a new security feature

https://lore.kernel.org/all/20210727205855.411487-1-keescook@chromium.org/

Tracking them would cost time I better spend on more important things
for now

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.

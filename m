Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFE565FF39
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jan 2023 11:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjAFK5v (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Jan 2023 05:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjAFK5u (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Jan 2023 05:57:50 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720636C28D;
        Fri,  6 Jan 2023 02:57:48 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pDkPy-0008Jr-N3; Fri, 06 Jan 2023 11:57:46 +0100
Message-ID: <f1ca3cea-01ae-998a-2aa8-c3e40cf46975@leemhuis.info>
Date:   Fri, 6 Jan 2023 11:57:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: =?UTF-8?Q?Re=3a_=5bregression=5d_Bug=c2=a0216785_-_=22memcpy=3a_det?=
 =?UTF-8?Q?ected_field-spanning_write=2e=2e=2e=22_warnings_with_bcache_=23fo?=
 =?UTF-8?Q?rregzbot?=
Content-Language: en-US, de-DE
To:     Kees Cook <keescook@chromium.org>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <19200730-a3ba-6f4f-bb81-71339bdbbf73@leemhuis.info>
 <2e4e65a8-87b4-fac6-ef89-76b118b0cec4@leemhuis.info>
 <202301052218.042D2BFE@keescook>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <202301052218.042D2BFE@keescook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1673002668;2b56280a;
X-HE-SMSGID: 1pDkPy-0008Jr-N3
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 06.01.23 07:22, Kees Cook wrote:
> On Thu, Dec 15, 2022 at 08:11:06AM +0100, Thorsten Leemhuis wrote:
>> [Note: this mail contains only information for Linux kernel regression
>> tracking. Mails like these contain '#forregzbot' in the subject to make
>> then easy to spot and filter out. The author also tried to remove most
>> or all individuals from the list of recipients to spare them the hassle.]
>>
>> On 08.12.22 15:53, Thorsten Leemhuis wrote:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=216785 :
>>>
>>>>  Alexandre Pereira 2022-12-07 18:51:55 UTC
>>>>
>>>> Testing linux kernel 6.1-rc8, I have several kernel erros regarding bcache.
>>>>
>>>> For context, I have a bcache configuration that is working without issues on 6.0.x and previous versions.
>>>>
>>>> The errors:
>>>>
>>>> dez 07 18:33:45 stormtrooper kernel: ------------[ cut here ]------------
>>>> dez 07 18:33:45 stormtrooper kernel: memcpy: detected field-spanning write (size 264) of single field "&i->j" at drivers/md/bcache/journal.c:152 (size 240)
>>
>> #regzbot inconclusive: stop tracking field-spanning write warnings, they
>> come from a new security feature
>>
>> https://lore.kernel.org/all/20210727205855.411487-1-keescook@chromium.org/
>>
>> Tracking them would cost time I better spend on more important things
>> for now
> 
> FWIW, I'd find it handy to see these. I've been trying to track and fix
> them. 

In that case I'd suggest: I forward any I see to you, but don't add them
 to the regressions tracked with regzbot.

Does that sound fine for you? Or is there a strong reason why I should
track them? Then they would be in the weekly reports to Linus, but I
wonder if he cares. At least for now now I guess he does not -- at some
later point where of the problems that are still hiding surfaced and
were fixed it might be something different. But then I could start
tracking them.

> To that end, I've just sent out the following patches:

Great!

Ciao, Thorsten

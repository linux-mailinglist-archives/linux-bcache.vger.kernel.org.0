Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99828536F34
	for <lists+linux-bcache@lfdr.de>; Sun, 29 May 2022 05:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiE2DSs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 28 May 2022 23:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiE2DSq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 28 May 2022 23:18:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AED5B82F2
        for <linux-bcache@vger.kernel.org>; Sat, 28 May 2022 20:18:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82AA0B8091E
        for <linux-bcache@vger.kernel.org>; Sun, 29 May 2022 03:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED82C3411B;
        Sun, 29 May 2022 03:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653794321;
        bh=CDnnHUSEc0WSSsFfZv1TIOuFOXKUplyIDrQx7pKH0co=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ofNVl3lg2Ew+sbbeAL2o09+SpWP/BoSU6UNFVRa5fGMs4GMIu6XpzuG/kD/qdSnDl
         ZHG0Eaf59DSbNfditqSANVBnBCQ0Is5W9+Xdg7d3S7Fda6M86JYTHKWvk2ssw5WeSZ
         +eHjmsLAvltgPwf5ys/3sC4y4c3S3gt8rWW9BrZvNn4h3UMj6w2Vm8KoLSPDbmLjis
         XBFDzNVPGsRPvIxeUxHrEO7dQrxhOlDiZoo33HL1bC6PHncjGIr7a+ZlPqr/haSpp1
         rvwps3OsiNkmM+MxZeOew2xtUGVBfBlSXpRW8Itg/ze6r5CfAUu0VoObzTqp1fqlJp
         KQXn0RjQnZ+lg==
Date:   Sat, 28 May 2022 21:18:38 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Adriano Silva <adriano_da_silva@yahoo.com.br>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>,
        Coly Li <colyli@suse.de>,
        Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
Message-ID: <YpLmDtMgyNLxJgNQ@kbusch-mbp.dhcp.thefacebook.com>
References: <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net>
 <27ef674d-67e-5739-d5d8-f4aa2887e9c2@ewheeler.net>
 <YoxuYU4tze9DYqHy@infradead.org>
 <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net>
 <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com>
 <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net>
 <Yo28kDw8rZgFWpHu@infradead.org>
 <a2ed37b8-2f4a-ef7a-c097-d58c2b965af3@ewheeler.net>
 <YpGsKDQ1aAzXfyWl@infradead.org>
 <24456292.2324073.1653742646974@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24456292.2324073.1653742646974@mail.yahoo.com>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, May 28, 2022 at 12:57:26PM +0000, Adriano Silva wrote:
> Dear Christoph,
> 
> > Once you do that, the block layer ignores all flushes and FUA bits, so
> > yes it is going to be a lot faster.  But also completely unsafe because
> > it does not provide any data durability guarantees.
> 
> Sorry, but wouldn't it be the other way around? Or did I really not understand your answer?
> 
> Sorry, I don't know anything about kernel code, but wouldn't it be the other way around?
> 
> It's just that, I may not be understanding. And it's likely that I'm not, because you understand more about this, I'm new to this subject. I know very little about it, or almost nothing.
> 
> But it's just that I've read the opposite about it.
> 
>  Isn't "write through" to provide more secure writes?
> 
> I also see that "write back" would be meant to be faster. No?

The sysfs "write_cache" attribute just controls what the kernel does. It
doesn't change any hardware settings.

In "write back" mode, a sync write will have FUA set, which will generally be
slower than a write without FUA. In "write through" mode, the kernel doesn't
set FUA so the data may not be durable after the completion if the controller
is using a volatile write cache.
 
> But I understand that when I do a write with direct ioping (-D) and with forced sync (-Y), then an enterprise NVME device with PLP (Power Loss Protection) like mine here should perform very well because in theory, the messages are sent to the hardware by the OS with an instruction for the Hardware to ignore the cache (correct?), but the NVME device will still put it in its local cache and give an immediate response to the OS saying that the data has been written, because he knows his local cache is a safe place for this (in theory).

If the device's power-loss protected memory is considered non-volatile, then it
shouldn't be reporting a volatile write cache, and it may complete commands
once the write data reaches its non-volatile cache. It can treat flush and FUA
as no-ops.
 
> On the other hand, answering why writing is slow when "write back" is activated is intriguing. Could it be the software logic stack involved to do the Write Back? I don't know.

Yeah, the software stack will issue flushes and FUA in "write back" mode.

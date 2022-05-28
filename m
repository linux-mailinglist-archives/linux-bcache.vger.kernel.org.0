Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A58536B5B
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 09:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiE1HWu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 28 May 2022 03:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiE1HWt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 28 May 2022 03:22:49 -0400
Received: from smtp.mfedv.net (smtp.mfedv.net [IPv6:2a04:6c0:2::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25509237EA
        for <linux-bcache@vger.kernel.org>; Sat, 28 May 2022 00:22:43 -0700 (PDT)
Received: from suse92host.mfedv.net (suse92host.mfedv.net [IPv6:2a04:6c0:2:3:0:0:0:ffff])
        by smtp.mfedv.net (8.15.2/8.15.2/Debian-10) with ESMTP id 24S7MUr5010091;
        Sat, 28 May 2022 09:22:31 +0200
Received: from xoff (klappe2.mfedv.net [192.168.71.72])
        by suse92host.mfedv.net (Postfix) with SMTP id 44BD4C809A;
        Sat, 28 May 2022 09:22:30 +0200 (CEST)
        (envelope-from bcache@mfedv.net)
Date:   Sat, 28 May 2022 09:22:30 +0200
From:   Matthias Ferdinand <bcache@mfedv.net>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Coly Li <colyli@suse.de>,
        Bcache Linux <linux-bcache@vger.kernel.org>
Subject: Re: Bcache in writes direct with fsync. Are IOPS limited?
Message-ID: <YpHNts38gQMJspip@xoff>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com>
 <958894243.922478.1652201375900@mail.yahoo.com>
 <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net>
 <681726005.1812841.1653564986700@mail.yahoo.com>
 <8aac4160-4da5-453b-48ba-95e79fb8c029@ewheeler.net>
 <532745340.2051210.1653624441686@mail.yahoo.com>
 <5b164113-364b-76a8-5bcc-94c1cec868db@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5b164113-364b-76a8-5bcc-94c1cec868db@ewheeler.net>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, May 27, 2022 at 06:27:53PM -0700, Eric Wheeler wrote:
> > I can say that the performance of tests after the write back command for 
> > all devices greatly worsens the performance of direct tests on NVME 
> > hardware. Below you can see this.
> 
> I wonder what is going on there!  I tried the same thing on my system and 
> 'write through' is faster for me, too, so it would be worth investigating.

In Ceph context, it seems not unusual to disable SSD write back cache
and see much improved performance (or the other way round: see
surprisingly low performance with write back cache enabled):

    https://yourcmc.ru/wiki/Ceph_performance#Drive_cache_is_slowing_you_down

Disk controllers seem to interpret FLUSH CACHE / FUA differently.
If bcache would set FUA for cache device writes while running fio
directly on the nvme device would not, that might explain the timing
difference.

Regards
Matthias

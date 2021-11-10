Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E07C44C30F
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Nov 2021 15:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhKJOiX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Nov 2021 09:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbhKJOiW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Nov 2021 09:38:22 -0500
Received: from forward501p.mail.yandex.net (forward501p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85689C061764
        for <linux-bcache@vger.kernel.org>; Wed, 10 Nov 2021 06:35:34 -0800 (PST)
Received: from myt5-ec37e7b64129.qloud-c.yandex.net (myt5-ec37e7b64129.qloud-c.yandex.net [IPv6:2a02:6b8:c05:ab:0:640:ec37:e7b6])
        by forward501p.mail.yandex.net (Yandex) with ESMTP id ADD816213726;
        Wed, 10 Nov 2021 17:35:30 +0300 (MSK)
Received: from 2a02:6b8:c12:2c9b:0:640:2b82:e4d1 (2a02:6b8:c12:2c9b:0:640:2b82:e4d1 [2a02:6b8:c12:2c9b:0:640:2b82:e4d1])
        by myt5-ec37e7b64129.qloud-c.yandex.net (mxback/Yandex) with HTTP id TZWbM63Du4Y1-ZUD0sYF7;
        Wed, 10 Nov 2021 17:35:30 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1636554930;
        bh=yVz5daM7PMciOtP9C5UmvMrsTdUTHVbFD07P49fSHS4=;
        h=Message-Id:Cc:Subject:In-Reply-To:Date:References:To:From;
        b=fySSc/LQf2xP8MLtLrj7kTfJlujN274++7QhO24shLOxRxikcTv5O+aBtIhVxYOL3
         x/ldhT749SloomGzMINVm5X3tngyB+ucbELCX2LMRuUcLmmz6WgoaCTNiLw4yiClQv
         2MIlUAFFtPNv6aI82yEaSEUi03Ilygl/SLi21M9A=
Authentication-Results: myt5-ec37e7b64129.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt6-2b82e4d1fc0a.qloud-c.yandex.net with HTTP;
        Wed, 10 Nov 2021 17:35:30 +0300
From:   Aleksei Zakharov <zakharov.a.g@yandex.ru>
Envelope-From: zakharov-a-g@yandex.ru
To:     Dongdong Tao <dongdong.tao@canonical.com>
Cc:     linux-bcache@vger.kernel.org
In-Reply-To: <CAJS8hV+KdLA6c8c5OV=z_KmJN2TSWROR6k9Y6_qut4EavJ0=tA@mail.gmail.com>
References: <10612571636111279@vla5-f98fea902492.qloud-c.yandex.net> <CAJS8hV+KdLA6c8c5OV=z_KmJN2TSWROR6k9Y6_qut4EavJ0=tA@mail.gmail.com>
Subject: Re: A lot of flush requests to the backing device
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Wed, 10 Nov 2021 17:35:30 +0300
Message-Id: <5218651636554930@myt6-2b82e4d1fc0a.qloud-c.yandex.net>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> [Sorry for the Spam detection ... ]
> 
> Hi Aleksei,
> 
> This is a very interesting finding, I understand that ceph blustore
> will issue fdatasync requests when it tries to flush data or metadata
> (via bluefs) to the OSD device. But I'm surprised to see so much
> pressure it can bring to the backing device.
> May I know how do you measure the number of flush requests to the
> backing device per second that is sent from the bcache with the
> REQ_PREFLUSH flag? (ftrace to some bcache tracepoint ?)
That was easy: the writeback rate was minimal and there were a lot
of write requests to the backing device in iostat -xtd 1 output and
bytes/s was too small for that number of writes. It was relatively old kernel,
so flushes were not separated in the block layer stats yet.

> 
> My understanding is that the bcache doesn't need to wait for the flush
> requests to be completed from the backing device in order to finish
> the write request, since it used a new bio "flush" for the backing
> device.
> So I don't think this will increase the fdatasync latency as long as
> the write can be performed in a writeback mode. It does increase the
> read latency if the read io missed the cache.
Hm, that might be truth for the reads, i'll do some experiments.
But, I don't see any reason to send flush request to the backing
device if there's nothing to flush.

> Or maybe I am missing something, let me know how did you observe the
> latency increasing from bcache layer , I would want to do some
> experiments as well?
I'll do some experiments and come back with more details on the
issue in a week! Already quit that job and don't work with ceph anymore,
but still thinking about this interesting issue.

> 
> Regards,
> Dongdong
> 
> On Fri, Nov 5, 2021 at 7:21 PM Aleksei Zakharov <zakharov.a.g@yandex.ru> wrote:
> 
>> Hi all,
>>
>> I've used bcache a lot for the last three years, mostly in writeback mode with ceph, and I faced a strange behavior. When there's a heavy write load on the bcache device with a lot of fsync()/fdatasync() requests, the bcache device issues a lot of flush requests to the backing device. If the writeback rate is low, then there might be hundreds of flush requests per second issued to the backing device.
>>
>> If the writeback rate growths, then latency of the flush requests increases. And latency of the bcache device increases as a result and the application experiences higher disk latency. So, this behavior of bcache slows the application in it's I/O requests when writeback rate becomes high.
>>
>> This workload pattern with a lot of fsync()/fdatasync() requests is a common for a latency-sensitive applications. And it seems that this bcache behavior slows down this type of workloads.
>>
>> As I understand, if a write request with REQ_PREFLUSH is issued to bcache device, then bcache issues new empty write request with REQ_PREFLUSH to the backing device. What is the purpose of this behavior? It looks like it might be eliminated for the better performance.
>>
>> --
>> Regards,
>> Aleksei Zakharov
>> alexzzz.ru
--
Regards,
Aleksei Zakharov
alexzzz.ru

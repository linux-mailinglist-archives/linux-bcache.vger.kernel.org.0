Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DE52B1FF4
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Nov 2020 17:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgKMQTP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-bcache@lfdr.de>); Fri, 13 Nov 2020 11:19:15 -0500
Received: from vostok.pvgoran.name ([71.19.149.48]:51775 "EHLO
        vostok.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgKMQTP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Nov 2020 11:19:15 -0500
Received: from [10.0.10.127] (l37-193-246-51.novotelecom.ru [::ffff:37.193.246.51])
  (AUTH: CRAM-MD5 main-collector@pvgoran.name, )
  by vostok.pvgoran.name with ESMTPSA
  id 0000000000085FD6.000000005FAEB202.000023BE; Fri, 13 Nov 2020 16:19:13 +0000
Date:   Fri, 13 Nov 2020 23:19:11 +0700
From:   Pavel Goran <via-bcache@pvgoran.name>
X-Mailer: The Bat! (v3.85.03) Professional
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
X-Priority: 3 (Normal)
Message-ID: <1726375278.20201113231911@pvgoran.name>
To:     Jean-Denis Girard <jd.girard@sysnux.pf>
CC:     linux-bcache@vger.kernel.org
Subject: Re[2]: bcache error -> btrfs unmountable
In-Reply-To: <romag0$2ci$1@ciao.gmane.io>
References: <rokg8t$u8n$1@ciao.gmane.io> <1854634128.20201113145913@pvgoran.name> <romag0$2ci$1@ciao.gmane.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Jean-Denis,

Friday, November 13, 2020, 10:58:56 PM, you wrote:

> Hello Pavel,

> Le 12/11/2020 a 21:59, Pavel Goran a ecrit :
>> Hello Jean-Denis,
>> 
>> See comments inline.
>> 
>> Friday, November 13, 2020, 6:25:15 AM, you wrote:
>> 
>>> Hi list,
>> 
>>> I have a RAID1 Btrfs (on sdb and sdc) behind bcache (on nvme0n1p4):
>> 
>> What's the cache mode? Writeback, writethrough, writearound?

> Sorry I forgot that important information: mode was Writeback.

>> You could try to detach the *cache* from the bcache devices, and then try to
>> use the bcache devices as before; it should be possible and harmless,
>> *unless* the cache mode is "writeback". If it's "writeback", things are more
>> complicated, and I'll leave them to more experienced people around.

> ok, as I have Writeback, I'll wait for further instructions.

First, you may want to check if there is any dirty data in the cache, by
executing:
cat /sys/block/bcache0/bcache/state
cat /sys/block/bcache1/bcache/state

If these return "clean", then you should be good to detach the cache.

You will want to try it *before* removing the faulty NVMe storage (which
would obviously make the cache device inaccessible).

>> IMPORANT: The kernel logs below indicate that bcache failed to do IO on the
>> cache device. It could be a hardware problem with your NVMe device, so I
>> suggest you look at its SMART, ASAP.

> Yes, the nvme is having problem... I'll replace it ASAP.


> Thanks for your reply Pavel,
> Best regards,

Pavel Goran
  


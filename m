Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046A32B1F63
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Nov 2020 16:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgKMP7E (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 13 Nov 2020 10:59:04 -0500
Received: from static.214.254.202.116.clients.your-server.de ([116.202.254.214]:42012
        "EHLO ciao.gmane.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbgKMP7E (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Nov 2020 10:59:04 -0500
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <glbd-linux-bcache@m.gmane-mx.org>)
        id 1kdbTa-00044q-2V
        for linux-bcache@vger.kernel.org; Fri, 13 Nov 2020 16:59:02 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-bcache@vger.kernel.org
From:   Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: bcache error -> btrfs unmountable
Date:   Fri, 13 Nov 2020 05:58:56 -1000
Message-ID: <romag0$2ci$1@ciao.gmane.io>
References: <rokg8t$u8n$1@ciao.gmane.io>
 <1854634128.20201113145913@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <1854634128.20201113145913@pvgoran.name>
Content-Language: fr
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Pavel,

Le 12/11/2020 à 21:59, Pavel Goran a écrit :
> Hello Jean-Denis,
> 
> See comments inline.
> 
> Friday, November 13, 2020, 6:25:15 AM, you wrote:
> 
>> Hi list,
> 
>> I have a RAID1 Btrfs (on sdb and sdc) behind bcache (on nvme0n1p4):
> 
> What's the cache mode? Writeback, writethrough, writearound?

Sorry I forgot that important information: mode was Writeback.


> You could try to detach the *cache* from the bcache devices, and then try to
> use the bcache devices as before; it should be possible and harmless,
> *unless* the cache mode is "writeback". If it's "writeback", things are more
> complicated, and I'll leave them to more experienced people around.

ok, as I have Writeback, I'll wait for further instructions.

> IMPORANT: The kernel logs below indicate that bcache failed to do IO on the
> cache device. It could be a hardware problem with your NVMe device, so I
> suggest you look at its SMART, ASAP.

Yes, the nvme is having problem... I'll replace it ASAP.


Thanks for your reply Pavel,
Best regards,
-- 
Jean-Denis Girard

SysNux                   Systèmes   Linux   en   Polynésie  française
https://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.527


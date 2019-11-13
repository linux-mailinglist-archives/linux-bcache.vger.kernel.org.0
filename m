Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5412AFAA0E
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2019 07:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfKMGK0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Nov 2019 01:10:26 -0500
Received: from smtp12.dentaku.gol.com ([203.216.5.74]:29066 "EHLO
        smtp12.dentaku.gol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfKMGK0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Nov 2019 01:10:26 -0500
Received: from batzmaru.gol.ad.jp ([203.216.0.80])
        by smtp12.dentaku.gol.com with esmtpa (Dentaku)
        (envelope-from <chibi@gol.com>)
        id 1iUlrD-0000GW-VK; Wed, 13 Nov 2019 15:10:24 +0900
Date:   Wed, 13 Nov 2019 15:10:22 +0900
From:   Christian Balzer <chibi@gol.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: Several bugs/flaws in the current(?) bcache implementation
Message-ID: <20191113151022.6c64d765@batzmaru.gol.ad.jp>
In-Reply-To: <3016280c-58c8-77f3-f938-4e835ab8d6c2@suse.de>
References: <20191111104219.6d12c4b6@batzmaru.gol.ad.jp>
        <a138b451-0a3e-2646-111e-cd095699ab0e@suse.de>
        <20191112101739.1c2517a4@batzmaru.gol.ad.jp>
        <a3d675f1-2309-d3fc-12b9-2ffb38ca5965@suse.de>
        <20191112153947.7acdc5a2@batzmaru.gol.ad.jp>
        <3016280c-58c8-77f3-f938-4e835ab8d6c2@suse.de>
Organization: Rakuten Communications
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV GOL (outbound)
X-GOL-Outbound-Spam-Score: -1.9
X-Abuse-Complaints: abuse@gol.com
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, 13 Nov 2019 11:44:50 +0800 Coly Li wrote:

[snip]
> 
> Hi Christian,
> 
> Could you please try the attached patch in your environment ? Let's see
> whether it makes things better on your side.
> 

Don't have custom/handrolled kernels on those machines, but I'll give it a
spin later.
Looking at the code I'm sure it will work, as in not going to full speed
when idle.

Is there any reason for this being a flag instead of actually setting the
max writeback rate, as mentioned when comparing this to MD RAID min/max?

What this does now is having writeback_rate_minimum both as the min and max
rate for non-dirty pressure flushing.
Whereas most people who want to actually set these values would probably
be interested in a min rate as it is now (to drain things effectively w/o
going overboard) and a max rate that never should be exceeded even if the
PDC thinks otherwise.

Regards,

Christian
-- 
Christian Balzer        Network/Systems Engineer                
chibi@gol.com   	Rakuten Mobile Inc.

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F9D48815B
	for <lists+linux-bcache@lfdr.de>; Sat,  8 Jan 2022 05:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiAHEyZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 7 Jan 2022 23:54:25 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:53842 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229527AbiAHEyY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 7 Jan 2022 23:54:24 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 52E7581;
        Fri,  7 Jan 2022 20:54:24 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id wLW4KuNBqH4k; Fri,  7 Jan 2022 20:54:19 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 1A62840;
        Fri,  7 Jan 2022 20:54:18 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 1A62840
Date:   Fri, 7 Jan 2022 20:54:16 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
cc:     Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent
 for hardware raid5/6
In-Reply-To: <yq15yqvw1f0.fsf@ca-mkp.ca.oracle.com>
Message-ID: <c9abd220-6b7f-9299-48a1-a16d64981734@ewheeler.net>
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de> <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net> <200638b0-7cba-38b4-20c4-b325f3cfe862@suse.de> <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net> <8a9131dc-9bf7-a24a-f7b8-35e0c019e905@suse.de>
 <fdb85dc1-eee6-e55e-8e9c-fa1f36b4a37@ewheeler.net> <yq15yqvw1f0.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, 7 Jan 2022, Martin K. Petersen wrote:
> Eric,
> 
> > Even new new RAID controlers that _do_ provide `io_opt` still do _not_ 
> > indicate partial_stripes_expensive (which is an mdraid feature, but Martin 
> > please correct me if I'm wrong here).
> 
> partial_stripes_expensive is a bcache thing, I am not sure why it needs
> a separate flag. It is implied, although I guess one could argue that
> RAID0 is a special case since partial writes are not as painful as with
> parity RAID.

I'm guessing bcache used did some optimization for 
queue->limits.raid_partial_stripes_expensive because md raid5 code sets 
this flag.  At least when using Linux md as the RAID5 implementation it 
gets configured automatically:
   raid5.c:       mddev->queue->limits.raid_partial_stripes_expensive = 1;

https://elixir.bootlin.com/linux/latest/source/drivers/md/raid5.c#L7729

Interestingly only bcache uses it, but md does set it.

> The SCSI spec states that submitting an I/O that is smaller than io_min
> "may incur delays in processing the command". And similarly, submitting
> a command larger than io_opt "may incur delays in processing the
> command".
> 
> IOW, the spec says "don't write less than an aligned multiple of the
> stripe chunk size" and "don't write more than an aligned full
> stripe". That leaves "aligned multiples of the stripe chunk size but
> less than the full stripe width" unaccounted for. And I guess that's
> what the bcache flag is trying to capture.

Maybe any time io_opt is provided then partial_stripes_expensive should be 
flagged too and any code to the contrary should be removed?

Question: Does anyone have a reason to keep partial_stripes_expensive in 
the kernel at all?

> SCSI doesn't go into details about RAID levels and other implementation
> details which is why the wording is deliberately vague. But obviously
> the expectation is that partial stripe writes are slower than full.
> 
> In my book any component in the stack that sees either io_min or io_opt
> should try very hard to send I/Os that are aligned multiples of those
> values. I am not opposed to letting users manually twiddle the
> settings. But I do think that we should aim for the stack doing the
> right thing when it sees io_opt reported on a device.

Agreed, thanks for the feedback!

-Eric


> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> 

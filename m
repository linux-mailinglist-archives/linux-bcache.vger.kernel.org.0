Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0600748A3A9
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jan 2022 00:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241865AbiAJXa3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 10 Jan 2022 18:30:29 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:47288 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241114AbiAJXa2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 10 Jan 2022 18:30:28 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 26AC54A;
        Mon, 10 Jan 2022 15:30:27 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 7WW_Nc2i1HIQ; Mon, 10 Jan 2022 15:30:26 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 3F41E39;
        Mon, 10 Jan 2022 15:30:26 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 3F41E39
Date:   Mon, 10 Jan 2022 15:30:24 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent
 for hardware raid5/6
In-Reply-To: <yq1fspvshbw.fsf@ca-mkp.ca.oracle.com>
Message-ID: <611f98fc-222-8dd2-6b81-d570fb91fc@ewheeler.net>
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de> <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net> <200638b0-7cba-38b4-20c4-b325f3cfe862@suse.de> <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net> <8a9131dc-9bf7-a24a-f7b8-35e0c019e905@suse.de>
 <fdb85dc1-eee6-e55e-8e9c-fa1f36b4a37@ewheeler.net> <yq15yqvw1f0.fsf@ca-mkp.ca.oracle.com> <c9abd220-6b7f-9299-48a1-a16d64981734@ewheeler.net> <98aa1886-859-abb9-164f-c9eb9be38a91@ewheeler.net> <yq1fspvshbw.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, 10 Jan 2022, Martin K. Petersen wrote:
> > Ok so `git blame` shows that Kent added this to md/raid5.c in 
> > c78afc6261b (Kent Overstreet 2013-07-11 22:39:53 -0700 7526)
> 
> Yep.
> 
> > Do you think we should leave the md-specific
> > raid_partial_stripes_expensive setting and require users of RAID
> > controllers to set the bit themselves in bcache---or---remove all
> > raid_partial_stripes_expensive code and always treat writes as
> > "expensive" when `opt_io` is defined?
> 
> I'd prefer the latter since that was the very intent of exporting the
> device topology in an abstract and protocol-independent fashion.
> However, I don't know enough about bcache internals to know whether it
> is always the right choice, what the trade-offs are, etc.

I've not looked in detail, but I don't think its too difficult.

Do you know if io_opt can be configured on scsi devices that do not have 
io_opt provided by the controller?  If so, or if it would be easy to add, 
then configuring io_opt at the scsi layer is probably a better option so 
subsystems besides bcache would benefit.

What do you think?

--
Eric Wheeler


> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> 

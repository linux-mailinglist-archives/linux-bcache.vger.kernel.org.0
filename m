Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF5A55CDF
	for <lists+linux-bcache@lfdr.de>; Wed, 26 Jun 2019 02:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfFZAXL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 25 Jun 2019 20:23:11 -0400
Received: from mx.ewheeler.net ([66.155.3.69]:47178 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFZAXL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Jun 2019 20:23:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 439D3A0692;
        Wed, 26 Jun 2019 00:23:10 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id XUUrvMZH-9KD; Wed, 26 Jun 2019 00:23:09 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 769DFA067D;
        Wed, 26 Jun 2019 00:23:09 +0000 (UTC)
Date:   Wed, 26 Jun 2019 00:23:09 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
cc:     Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "open list\\:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list\\:BCACHE \\(BLOCK LAYER CACHE\\)" 
        <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent
 for hardware raid5/6
In-Reply-To: <yq17e9ao9c3.fsf@oracle.com>
Message-ID: <alpine.LRH.2.11.1906260005570.1114@mx.ewheeler.net>
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de>        <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net>        <200638b0-7cba-38b4-20c4-b325f3cfe862@suse.de>        <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net>
 <yq17e9ao9c3.fsf@oracle.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, 24 Jun 2019, Martin K. Petersen wrote:
> > Perhaps they do not set stripe_width using io_opt? I did a grep to see
> > if any of them did, but I didn't see them. How is stripe_width
> > indicated by RAID controllers?
> 
> The values are reported in the Block Limits VPD page for each SCSI block
> device and are thus set by the SCSI disk driver. IOW, the RAID
> controller device drivers have nothing to do with this.
> 
> For RAID controllers specifically, the controller firmware will fill out
> the VPD fields for each virtual SCSI disk when you configure a RAID
> set. For pretty much everything else, the Block Limits come straight
> from the device itself.
> 
> Also note that these values aren't specific to RAID controllers at
> all. Most new SCSI devices, including disk drives and SSDs, will fill
> out the Block Limits VPD page one way or the other. Even some USB
> storage devices are providing this page.

Thanks, that makes sense.  Interesting about USB.

> > If they do set io_opt, then at least my Areca 1883 does not set io_opt
> > as of 4.19.x. I also have a LSI MegaRAID 3108 which does not report
> > io_opt as of 4.1.x, but that is an older kernel so maybe support has
> > been added since then.
> 
> I have several MegaRAIDs that all report it. But it depends on the
> controller firmware.
> 
> > Is it visible through sysfs or debugfs so I can check my hardware
> > support without hacking debugging the kernel?
> 
> To print the block device topology:
> 
>   # lsblk -t
> 
> or look up io_opt in sysfs:
> 
>   # grep . /sys/block/sdX/queue/optimal_io_size
> 
> You can also query a SCSI device's Block Limits directly:
> 
>   # sg_vpd -p bl /dev/sdX

Perfect, thank you for that.  I've tried the following controllers that I 
have access to.  One worked (hspa/HP Gen8 Smart Array Controller), but the 
others I tried are not providing VPDs:

* LSI 2108 (Supermicro)
* LSI 3108 (Dell)
* Areca 1882
* Areca 1883
* Fibrechannel 8gbe connected to a Storwize 3700

~]# sg_vpd -p bl /dev/sdb
VPD page=0xb0
fetching VPD page failed

> If you want to tinker, you can simulate a SCSI disk with your choice of
> io_opt:
> 
>   # modprobe scsi_debug opt_blks=N
> 
> where N is the number of logical blocks to report as being the optimal
> I/O size.

Neat, thanks for the hint!

-Eric

> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> 

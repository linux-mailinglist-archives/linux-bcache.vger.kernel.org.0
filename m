Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C6C452FB9
	for <lists+linux-bcache@lfdr.de>; Tue, 16 Nov 2021 12:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhKPLFx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 16 Nov 2021 06:05:53 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:54506 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbhKPLFZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 16 Nov 2021 06:05:25 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 670CF1FCA1;
        Tue, 16 Nov 2021 11:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637060547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MLmhZein5gKYUOmMV8s+58ogFYZvARrwrPj0Dqr0jl4=;
        b=iPooB6rIe/rgz2WTnSfkv3LjiK7PoMk8XuFztUnL3p52KhWwzMTrt70hWVqvc2RFThF90L
        TkQavAE/yvUzxqjKOMeBvxNsne+yItH7jI44/+kwNu3KModu7Uadkm/USqKAVbO6hcN0cL
        sPNmaCgcSajknuAJRRjIP4BvTHEbXLo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637060547;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MLmhZein5gKYUOmMV8s+58ogFYZvARrwrPj0Dqr0jl4=;
        b=YOSAMPpOvG6XMSo0KMQdgwK0KApWsIjSww0YOaQVEG90wbQXQjKbB+sq+WbL0spLXrHo8q
        YOgE36/M7WC3qSCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BE9D613C06;
        Tue, 16 Nov 2021 11:02:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XZLjI8KPk2EvOAAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 16 Nov 2021 11:02:26 +0000
Message-ID: <7485d9b0-80f4-4fff-5a0c-6dd0c35ff91b@suse.de>
Date:   Tue, 16 Nov 2021 19:02:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: Consistent failure of bcache upgrading from 5.10 to 5.15.2
Content-Language: en-US
To:     Kai Krakow <kai@kaishome.de>
References: <CAC2ZOYtu65fxz6yez4H2iX=_mCs6QDonzKy7_O70jTEED7kqRQ@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
In-Reply-To: <CAC2ZOYtu65fxz6yez4H2iX=_mCs6QDonzKy7_O70jTEED7kqRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 11/16/21 6:10 PM, Kai Krakow wrote:
> Hello Coly!
>
> I think I can consistently reproduce a failure mode of bcache when
> going from 5.10 LTS to 5.15.2 - on one single system (my other systems
> do just fine).
>
> In 5.10, bcache is stable, no problems at all. After booting to
> 5.15.2, btrfs would complain about broken btree generation numbers,
> then freeze completely. Going back to 5.10, bcache complains about
> being broken and cannot start the cache set.
>
> I was able to reproduce the following behavior after the problem
> struck me twice in a row:
>
> 1. Boot into SysRescueCD
> 2. modprobe bcache
> 3. Manually detach the btrfs disks from bcache, set cache mode to
> none, force running
> 4. Reboot into 5.15.2 (now works)
> 5. See this error in dmesg:
>
> [   27.334306] bcache: bch_cache_set_error() error on
> 04af889c-4ccb-401b-b525-fb9613a81b69: empty set at bucket 1213, block
> 1, 0 keys, disabling caching
> [   27.334453] bcache: cache_set_free() Cache set
> 04af889c-4ccb-401b-b525-fb9613a81b69 unregistered
> [   27.334510] bcache: register_cache() error sda3: failed to run cache set
> [   27.334512] bcache: register_bcache() error : failed to register device
>
> 6. wipefs the failed bcache cache
> 7. bcache make -C -w 512 /dev/sda3 -l bcache-cdev0 --force
> 8. re-attach the btrfs disks in writearound mode
> 9. btrfs immediately fails, freezing the system (with transactions IDs way off)
> 10. reboot loops to 5, unable to mount
> 11. escape the situation by starting at 1, and not make a new bcache
>
> Is this a known error? Why does it only hit this machine?
>
> SSD Model: Samsung SSD 850 EVO 250GB

This is already known, there are 3 locations to fix,

1, Revert commit 2fd3e5efe791946be0957c8e1eed9560b541fe46
2, Revert commit  f8b679a070c536600c64a78c83b96aa617f8fa71
3, Do the following change in drivers/md/bcache.c,
@@ -885,9 +885,9 @@ static void bcache_device_free(struct bcache_device *d)

  		bcache_device_detach(d);
  
  	if (disk) {
-		blk_cleanup_disk(disk);
  		ida_simple_remove(&bcache_device_idx,
  				  first_minor_to_idx(disk->first_minor));
+		blk_cleanup_disk(disk);
  	}

The fix 1) and 3) are on the way to stable kernel IMHO, and fix 2) is only my workaround and I don't see upstream fix yet.

Just FYI.

Coly Li


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566D74F8552
	for <lists+linux-bcache@lfdr.de>; Thu,  7 Apr 2022 18:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbiDGQ4C (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 7 Apr 2022 12:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiDGQ4B (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Apr 2022 12:56:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7431237CA
        for <linux-bcache@vger.kernel.org>; Thu,  7 Apr 2022 09:54:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9498B1F85A;
        Thu,  7 Apr 2022 16:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649350440; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C1vbUChFEfa4PgBC1Y2hts55eyS9uTgfV8n/7K0YH3s=;
        b=CCJl7kTaGQtXviFqUklG8JFuehRsj8GOic1LRrzzcisV122/dz0ehY2uf9bxgGx6IRlcVZ
        bhkqkYoJ+2hoY3vM+w+HGmPXGkOFSYLbPLInWVWWFkbx07sYfqkPUh+8yunC8CYQTqceh8
        ObFAtc9QTLprBld0SmFiqN2Zx2GKKuc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649350440;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C1vbUChFEfa4PgBC1Y2hts55eyS9uTgfV8n/7K0YH3s=;
        b=wRnMmkzzHtfT9ymMZwx6a4Sqq0uDvouya59AhYU0pc9wBI+QAxmO9G3uj8WlLWmlwIb2M7
        BFoORFzSClK5YxAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A8DA813485;
        Thu,  7 Apr 2022 16:53:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4aTdHicXT2K2GQAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 07 Apr 2022 16:53:59 +0000
Message-ID: <40862b68-e81d-089b-d713-b0e6e2bd7e04@suse.de>
Date:   Fri, 8 Apr 2022 00:53:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] bcache: remove unnecessary flush_workqueue
Content-Language: en-US
To:     Li Lei <noctis.akm@gmail.com>
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        Li Lei <lilei@szsandstone.com>
References: <20220327072038.12385-1-lilei@szsandstone.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220327072038.12385-1-lilei@szsandstone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/27/22 3:20 PM, Li Lei wrote:
> All pending works will be drained by destroy_workqueue(), no need to call
> flush_workqueue() explicitly.
>
> Signed-off-by: Li Lei <lilei@szsandstone.com>
> ---
>   drivers/md/bcache/writeback.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 9ee0005874cd..2a6d9f39a9b1 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -793,10 +793,9 @@ static int bch_writeback_thread(void *arg)
>   		}
>   	}
>   
> -	if (dc->writeback_write_wq) {
> -		flush_workqueue(dc->writeback_write_wq);
> +	if (dc->writeback_write_wq)
>   		destroy_workqueue(dc->writeback_write_wq);
> -	}
> +
>   	cached_dev_put(dc);
>   	wait_for_kthread_stop();
>   

The above code is from commit 7e865eba00a3 ("bcache: fix potential 
deadlock in cached_def_free()"). I explicitly added extra 
flush_workqueue() was because of workqueue_sysfs_unregister(wq) in 
destory_workqueue().

workqueue_sysfs_unregister() is not simple because it calls 
device_unregister(), and the code path is long. During reboot I am not 
sure whether extra deadlocking issue might be introduced. So the safe 
way is to explicitly call flush_workqueue() firstly to wait for all 
kwork finished, then destroy it.

It has been ~3 years passed, now I am totally OK with your above change. 
But could you please test your patch with lockdep enabled, and see 
whether there is no lock warning observed? Then I'd like to add it into 
my test directory.


Thanks.

Coly Li


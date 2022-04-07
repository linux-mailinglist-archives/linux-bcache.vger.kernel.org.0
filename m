Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE514F8507
	for <lists+linux-bcache@lfdr.de>; Thu,  7 Apr 2022 18:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiDGQcy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 7 Apr 2022 12:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiDGQcx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Apr 2022 12:32:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808712654B;
        Thu,  7 Apr 2022 09:30:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 405961F85E;
        Thu,  7 Apr 2022 16:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649349051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kwxyzYgGecFmKu7vVopGLal+04ie4RFx7Rbwzskq19U=;
        b=Z4JGpQE9BpEQBn3gWuG4Zx0MsBAvCoE+v6pDoNN74Byhet9/WlLpNpPb9y/sPKrXpfYxlg
        Hhu+LgSsAQewxnSFmROGC4E4hFDD2oT5KzKB5LOXbLTVNokzyHoINEJ4o0Al2uAn2bE2Pd
        v7pRPe8ATHi1sZgx6Q7vRUYYtbr1NBo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649349051;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kwxyzYgGecFmKu7vVopGLal+04ie4RFx7Rbwzskq19U=;
        b=dh/mp+RKVDGspRw98CTISYUdoI6ozOJYJ3rJlWSl/Qk2IuiZlS99gwb3/1KENpI9u6TfHa
        MZcOUNEj9va2FHBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 02A4013A66;
        Thu,  7 Apr 2022 16:30:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VG/mL7kRT2LMDwAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 07 Apr 2022 16:30:49 +0000
Message-ID: <b97d4326-3ce7-63d2-e4b6-8fbd27335fce@suse.de>
Date:   Fri, 8 Apr 2022 00:30:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v1] bcache: fix AB-BA deadlock between cache register and
 cache_set_free
Content-Language: en-US
To:     daihuaigang129@163.com
Cc:     linux-bcache@vger.kernel.org, kent.overstreet@gmail.com,
        linux-kernel@vger.kernel.org
References: <1648523845-4681-1-git-send-email-daihuaigang129@163.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <1648523845-4681-1-git-send-email-daihuaigang129@163.com>
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

On 3/29/22 11:17 AM, daihuaigang129@163.com wrote:
> From: daihuaigang <daihuaigang129@163.com>
>
> bcache register add kobject_mutex then bch_register_mutex,
> cache_set_free add bch_register_mutex then kobject_mutex.
> fix AB-BA deadlock between cache register and cache_set_free.

Can you explain a bit more about,

- For "bcache register add kobject_mutex", which function referred by 
"bcache register add", and where is the kobject_mutex.

- Where is bch_regsiter_mutex.

It is not clear for me to understand how hte AB-BA deadlock generated yet.

Thanks.


Coly Li


>
> Signed-off-by: daihuaigang <daihuaigang129@163.com>
> ---
>   drivers/md/bcache/super.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index bf3de14..f17953c 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1690,10 +1690,8 @@ static void cache_set_free(struct closure *cl)
>   	if (ca) {
>   		ca->set = NULL;
>   		c->cache = NULL;
> -		kobject_put(&ca->kobj);
>   	}
>   
> -
>   	if (c->moving_gc_wq)
>   		destroy_workqueue(c->moving_gc_wq);
>   	bioset_exit(&c->bio_split);
> @@ -1704,6 +1702,8 @@ static void cache_set_free(struct closure *cl)
>   
>   	list_del(&c->list);
>   	mutex_unlock(&bch_register_lock);
> +	if (ca)
> +		kobject_put(&ca->kobj);
>   
>   	pr_info("Cache set %pU unregistered\n", c->set_uuid);
>   	wake_up(&unregister_wait);



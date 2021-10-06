Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25262423E8B
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Oct 2021 15:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbhJFNWG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 6 Oct 2021 09:22:06 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:49692 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbhJFNWF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Oct 2021 09:22:05 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B80E62249D;
        Wed,  6 Oct 2021 13:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633526412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4hahSfVW7Rs+miJSOv7LC4RMTVprjj5yLE54zOSIy70=;
        b=XO+SlYUmlxmOr1GbLoSs6so7HLn5DXWLZChgN6Achv9du/OAD71kjUHWxGmPB/M+Mvq+GE
        FnBwZZX2UIJrIBgd9WZRCp+9uopO6towcx9UuKkJXm4BwjBtaGDHBvoH9daAyn7Oi84mBw
        cNfSHo+5KvJ49gkOKGcLLWqV1QcYTmg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633526412;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4hahSfVW7Rs+miJSOv7LC4RMTVprjj5yLE54zOSIy70=;
        b=NDDHPreIkYO+s1lGKh6G5FsJSoRztLHODEw0FMxsk1fG5/FJdXX0ykDUp1sIyW1v6EGkRg
        kopKjdpNEdvoBeBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E54F413C57;
        Wed,  6 Oct 2021 13:20:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OgI0LIuiXWH3WQAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 06 Oct 2021 13:20:11 +0000
Subject: Re: [PATCH] bcache: remove unnecessary code in gc
To:     Li Lei <lilei@szsandstone.com>
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
References: <20211006080412.16251-1-lilei@szsandstone.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <50cde730-06e2-0cb6-085a-cc5a76499a0a@suse.de>
Date:   Wed, 6 Oct 2021 21:20:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211006080412.16251-1-lilei@szsandstone.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/6/21 4:04 PM, Li Lei wrote:
> Originally, btree_gc_start() ran in workqueue, it would be called
> simutaneously in different threads, c->gc_mark_valid was used to make
> sure there was only one thread to do GC.
>
> Since gc has been converted to a kthread, there is no need to the check.
>
> Signed-off-by: Li Lei <lilei@szsandstone.com>
> ---
>   drivers/md/bcache/btree.c | 3 ---
>   1 file changed, 3 deletions(-)
>
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index fe6dce125aba..b18e1fd2c209 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1698,9 +1698,6 @@ static void btree_gc_start(struct cache_set *c)
>   	struct cache *ca;
>   	struct bucket *b;
>
> -	if (!c->gc_mark_valid)
> -		return;
> -

Do you have any performance number for the above change ? I am not sure 
whether the change may offer benefit for bcache gc, correct me if I am 
wrong.

Coly Li

>   	mutex_lock(&c->bucket_lock);
>
>   	c->gc_mark_valid = 0;
> --
> 2.25.1
>
>
>
>


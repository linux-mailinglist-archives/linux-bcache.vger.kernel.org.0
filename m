Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F3249AB02
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Jan 2022 05:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S247782AbiAYDyU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Jan 2022 22:54:20 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:47120 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415321AbiAYBmj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Jan 2022 20:42:39 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2AC34219A2;
        Tue, 25 Jan 2022 01:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643073984; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ukdL4uSY7ajaeLLyOy2K7g+OJNEsLFNzoe0K6HxbbBg=;
        b=BwXWmNKUWNf/QWwndBHhxlD2Xpth4f7ipnaSxOD2XBfHipf1jgH6D0R2Spb2M3qCWIYW6m
        x8HgPaGGvhDhmCSwpUrMVDzLVO3WKJuln+opQ2oqurTLT2CirjYFmmlkxIvnmpobc9OcMr
        /XVRrjkS2Bwcj0UP8GK7CtnWdspz7kU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643073984;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ukdL4uSY7ajaeLLyOy2K7g+OJNEsLFNzoe0K6HxbbBg=;
        b=l73U2zJamff6zF7815X4J+N8Rh0uBqiHROilqBddtxvC5Hb7ncpUxcTc2cZAgSaKaR9EEQ
        EVSFagbOQhELLeDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EA36B13B08;
        Tue, 25 Jan 2022 01:26:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aIQzLb5R72HYGQAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 25 Jan 2022 01:26:22 +0000
Message-ID: <e3771b5d-87dc-d38e-a957-5ef044a0d5cc@suse.de>
Date:   Tue, 25 Jan 2022 09:26:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH] bcache: Fix a NULL or wild pointer dereference in
 btree_gc_rewrite_node()
Content-Language: en-US
To:     Zhou Qingyang <zhou1615@umn.edu>
Cc:     kjlu@umn.edu, Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220124164701.53525-1-zhou1615@umn.edu>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220124164701.53525-1-zhou1615@umn.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/25/22 12:47 AM, Zhou Qingyang wrote:
> In btree_gc_rewrite_node(), btree_node_alloc_replacement() is assigned to
> n and return error code or NULL on failure. n is passed to
> bch_btree_node_write_sync() and there is a dereference of it in
> bch_btree_node_write_sync() without checks, which may lead to wild
> pointer dereference or NULL pointer dereference depending on n.
>
> Fix this bug by adding IS_ERR_OR_NULL check of n.
>
> This bug was found by a static analyzer.
>
> Builds with 'make allyesconfig' show no new warnings,
> and our static analyzer no longer warns about this code.
>
> Fixes: ("bcache: Rework btree cache reserve handling")
> Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
> ---
> The analysis employs differential checking to identify inconsistent
> security operations (e.g., checks or kfrees) between two code paths
> and confirms that the inconsistent operations are not recovered in the
> current function or the callers, so they constitute bugs.
>
> Note that, as a bug found by static analysis, it can be a false
> positive or hard to trigger. Multiple researchers have cross-reviewed
> the bug.
>
>   drivers/md/bcache/btree.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 88c573eeb598..06d42292e86c 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1504,6 +1504,8 @@ static int btree_gc_rewrite_node(struct btree *b, struct btree_op *op,
>   		return 0;
>   
>   	n = btree_node_alloc_replacement(replace, NULL);
> +	if (IS_ERR_OR_NULL(n))
> +		return 0;
>   

Hi Qingyang,

This is a valid fix with my first glance. I add this patch into my 
testing queue.

Thanks.

Coly Li


>   	/* recheck reserve after allocating replacement node */
>   	if (btree_check_reserve(b, NULL)) {


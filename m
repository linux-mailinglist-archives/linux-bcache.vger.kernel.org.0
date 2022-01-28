Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B586849F718
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jan 2022 11:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344999AbiA1KSM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jan 2022 05:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346937AbiA1KSA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jan 2022 05:18:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B5DC06175D;
        Fri, 28 Jan 2022 02:17:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3461761E51;
        Fri, 28 Jan 2022 10:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBEDC340EB;
        Fri, 28 Jan 2022 10:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643365078;
        bh=lshUfTJFHFj4Xt/uIgskMDM4p57r2Pvvnd2wk+sBnUE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N0VQjGfqz13Px2iWGGgo7Ula5GRv/NJ8ebQkdOmZlqG3R1SUtUXo0j6SUqFfkjJiA
         MLiIIV0BH8a33jSxiS2+hq7cR8dOzM2H2ue8Aop29LXvnQztWwWQnWMYIoQfaTXIov
         iimOVXEQ0mnz4JhR+6vXhI1lOVn59CmvXUS3uGxo=
Date:   Fri, 28 Jan 2022 11:17:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhou Qingyang <zhou1615@umn.edu>
Cc:     kjlu@umn.edu, Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcache: Fix a NULL or wild pointer dereference in
 btree_gc_rewrite_node()
Message-ID: <YfPC0B9mBE/hkKEO@kroah.com>
References: <20220124164701.53525-1-zhou1615@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124164701.53525-1-zhou1615@umn.edu>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Jan 25, 2022 at 12:47:01AM +0800, Zhou Qingyang wrote:
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
>  drivers/md/bcache/btree.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 88c573eeb598..06d42292e86c 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1504,6 +1504,8 @@ static int btree_gc_rewrite_node(struct btree *b, struct btree_op *op,
>  		return 0;
>  
>  	n = btree_node_alloc_replacement(replace, NULL);
> +	if (IS_ERR_OR_NULL(n))
> +		return 0;
>  
>  	/* recheck reserve after allocating replacement node */
>  	if (btree_check_reserve(b, NULL)) {
> -- 
> 2.25.1
> 

As stated before, umn.edu is still not allowed to contribute to the
Linux kernel.  Please work with your administration to resolve this
issue.


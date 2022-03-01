Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EE64C8DA2
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Mar 2022 15:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbiCAO0p (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 1 Mar 2022 09:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbiCAO0o (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Mar 2022 09:26:44 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC5A6E4C9;
        Tue,  1 Mar 2022 06:26:02 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A216C2110B;
        Tue,  1 Mar 2022 14:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1646144761;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=igSUBiGP75gcwuKKcw5IrELkytjlsx5b26P1/uxLTDI=;
        b=m4GhdnjslealexAP/oRzJR1pak++pQpgQY4kGvEzjaC3YgUl6DX+wndyUWZb7LLrMlUDUL
        bDXGGES3NylgjPmmsF6g4hclkisVsizYxF7LUGh4WuoXDGkJOvlIsbr9g2ywdN4oZ/N8I5
        Egd3FZTeVFhYl7SEjKJmrYj0gjJMsmc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1646144761;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=igSUBiGP75gcwuKKcw5IrELkytjlsx5b26P1/uxLTDI=;
        b=AS2kmChYl/LTYbL9BGHDEoAKkBtbDX0SK3ZHu2HGLBKbGwSLvwAIOHJkcZ711kpgGAIw50
        0JidFyRYjfU/SpDg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 600F3A3B81;
        Tue,  1 Mar 2022 14:26:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E36AEDA80E; Tue,  1 Mar 2022 15:22:09 +0100 (CET)
Date:   Tue, 1 Mar 2022 15:22:09 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] btrfs: simplify ->flush_bio handling
Message-ID: <20220301142209.GN12643@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20220301084552.880256-1-hch@lst.de>
 <20220301084552.880256-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301084552.880256-2-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Mar 01, 2022 at 10:45:48AM +0200, Christoph Hellwig wrote:
> @@ -6962,16 +6961,6 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
>  	if (!dev)
>  		return ERR_PTR(-ENOMEM);
>  
> -	/*
> -	 * Preallocate a bio that's always going to be used for flushing device
> -	 * barriers and matches the device lifespan
> -	 */
> -	dev->flush_bio = bio_kmalloc(GFP_KERNEL, 0);
> -	if (!dev->flush_bio) {
> -		kfree(dev);
> -		return ERR_PTR(-ENOMEM);
> -	}
> -
>  	INIT_LIST_HEAD(&dev->dev_list);
>  	INIT_LIST_HEAD(&dev->dev_alloc_list);
>  	INIT_LIST_HEAD(&dev->post_commit_list);
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 005c9e2a491a1..9af7b6211920c 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -117,7 +117,7 @@ struct btrfs_device {
>  	u64 commit_bytes_used;
>  
>  	/* for sending down flush barriers */
> -	struct bio *flush_bio;

Please add this comment to the struct member declaration:

	/* Bio used for flushing device barriers */

> +	struct bio flush_bio;

Otherwise

Reviewed-by: David Sterba <dsterba@suse.com>

Thanks.

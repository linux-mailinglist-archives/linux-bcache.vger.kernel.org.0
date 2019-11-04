Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E54EE714
	for <lists+linux-bcache@lfdr.de>; Mon,  4 Nov 2019 19:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbfKDSOH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Nov 2019 13:14:07 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40761 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbfKDSOG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Nov 2019 13:14:06 -0500
Received: by mail-qk1-f196.google.com with SMTP id a18so899320qkk.7;
        Mon, 04 Nov 2019 10:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CESSF5qn5Qy1BsK9cSv3ooZQ0bXf2ohjxEDHCQYKAtY=;
        b=bbBev0z0ZJgRVN64Ta4O0Y630R1T16xvmTzoDGJvanMDytqaW2ks41pi5XDQQv6ckh
         aFzDgqJRv6pLLvw4LQ0ef33lMYuol/kkthFp6ZTOjJxjZMO7VLdEZfG47Ojcdnw4mUqx
         vC19/O4cWztFDNNdIkolaFVMk4m1dyNOTrk8BY5KKTbW3gewkagEypksMSyMzHMc3VTM
         2VJSFTpQZbmuY9BTAfzi5GOPaARQa/iY6DHgiIdtix0xL5OXWSOQmHOpyB9kst/g2aWz
         1ENLCgKbv8Fki4yKuch06VgArWZlGqAv4KZroYec0DxHWTgZb99eIQleTR0eJVSLa42o
         p9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CESSF5qn5Qy1BsK9cSv3ooZQ0bXf2ohjxEDHCQYKAtY=;
        b=hZRjdiTcFYX4Bh6THTTXlV3M0cnGBtafH1f1QY/ttusWzCQO6WKLcenATf8A7EpJOC
         0Q5uf6/nUTM9BMvncCXatvOKK2OOOnn+H4U2X34puUhAPhxVy5OY/oRZ6OxkzAJu60qT
         KZAmcM9Ok9GizB7lfiH1eFP9YHU53FszkjzKpQy38QofyRiKKPlWDGqlarastz/rEfBS
         4GrDsABK5XvL9Pv1dh78XZQEa1OXZ2uoEdzxE9f49yiVjSupPl7ErA+UTvIgSrn/ldPh
         ISbe3pGTRl4QPliqnc7Vtkukm3ecDpl5ON6x8kIVAIxPw9R7JQFTfTq5OwBkqbduv2eH
         hW1Q==
X-Gm-Message-State: APjAAAV9NMNJFTj/AMf5bh4vvwY/f9vZUz1UWI/9q/luYwDt47ktwxK9
        O1OLdk4I6hU8/Uj3+Fp7R6gh9ak=
X-Google-Smtp-Source: APXvYqxUaKEF4+SNjFWN9SPMlt/WM8ySSX7s6Z5IiCYRUwP2UY0BGwuamZ0ntDOPQlEs6solywT93g==
X-Received: by 2002:a37:4f0a:: with SMTP id d10mr17943522qkb.286.1572891245747;
        Mon, 04 Nov 2019 10:14:05 -0800 (PST)
Received: from kmo-pixel ([65.183.151.50])
        by smtp.gmail.com with ESMTPSA id a3sm8515824qkf.76.2019.11.04.10.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 10:14:05 -0800 (PST)
Date:   Mon, 4 Nov 2019 13:14:03 -0500
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Keith Busch <kbusch@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [PATCH V4] block: optimize for small block size IO
Message-ID: <20191104181403.GA8984@kmo-pixel>
References: <20191102072911.24817-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191102072911.24817-1-ming.lei@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, Nov 02, 2019 at 03:29:11PM +0800, Ming Lei wrote:
> __blk_queue_split() may be a bit heavy for small block size(such as
> 512B, or 4KB) IO, so introduce one flag to decide if this bio includes
> multiple page. And only consider to try splitting this bio in case
> that the multiple page flag is set.

So, back in the day I had an alternative approach in mind: get rid of
blk_queue_split entirely, by pushing splitting down to the request layer - when
we map the bio/request to sgl, just have it map as much as will fit in the sgl
and if it doesn't entirely fit bump bi_remaining and leave it on the request
queue.

This would mean there'd be no need for counting segments at all, and would cut a
fair amount of code out of the io path.

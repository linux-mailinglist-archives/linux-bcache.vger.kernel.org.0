Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20285EE72D
	for <lists+linux-bcache@lfdr.de>; Mon,  4 Nov 2019 19:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfKDSRq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Nov 2019 13:17:46 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37351 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDSRq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Nov 2019 13:17:46 -0500
Received: by mail-qt1-f193.google.com with SMTP id g50so25357435qtb.4;
        Mon, 04 Nov 2019 10:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HzVYOa9YY1QuhPjzrlasHZ/KszbX+V3HmCP2rM3NqdA=;
        b=rgnpWQM51j0QwW8a60OrYGBnre9cewSfn1nT2lFOlBozsUnyrdvcu0XWv1GMdpP2si
         4teO0V84uSiVGKI6pGSsSG8iropMbCtPPQ4bkY4icE21185+z5VXoz0uPDmSYWqjPyy/
         tIJRCei+0baObEjTBJyEpnq300EgOtLo8XoL3ortHN/uDZh7ezT+VwL31CSMiFMcf+s5
         kdvHxLJSaJvh71L/7+ZOUbn2JoZ9VvIMSksOAwd6ZisQozo5BhGnPrR3wJ6acm7VT43x
         LMhP8z98I2+2ptFCR0iuPrIqohWXYMEk2p11dcjgLHWUyaqGhV/z2DdEsZW4ssQB6OE8
         mzxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HzVYOa9YY1QuhPjzrlasHZ/KszbX+V3HmCP2rM3NqdA=;
        b=DMAs8vUd08GEtILA0NmHviLuXp/n1XTlOMVy2cNGmgi0T3FfAmokAriYvj14GtEV1F
         SGQXlKl+ls+n2QjNEHmOElHEc7ptn/qhpEfqsK+gswKfwiG/nSXUNuajxwEpphvPk2FK
         XVRBXmp0JPu5DJ4r5j7YnQkaCZ9Zd0CT3R26cRSYaH9oVwkLtQQBaPYtq1bKd1eBbYMr
         8VcvKRJEWBxjXBBv89H/9Y6FdW2dMSlrQbVHrKwSWE2EyaRDtJcIraHrrjgwY9ZcefeW
         24GZ3lm4m07AI9P6p9E/KLd1E9PYwyl1CTbKokFzKn5aObAsOG/MnKfTYtjJhreMWEPO
         y1tw==
X-Gm-Message-State: APjAAAXsgkwXp4XZ2U2YFPIrfrWAgUbIMrEhCIKjjzbeFpv/56xpjXre
        f5CfIvQw3x5KOUBS0+Hd7w==
X-Google-Smtp-Source: APXvYqxTQeoueWQq+vUxLFzFSzns595VUVHtFSuOH5ZeF2s3wNLCxARNaIQtZovaCIYVdEkqtD+1vA==
X-Received: by 2002:ac8:151:: with SMTP id f17mr13246735qtg.92.1572891465355;
        Mon, 04 Nov 2019 10:17:45 -0800 (PST)
Received: from kmo-pixel ([65.183.151.50])
        by smtp.gmail.com with ESMTPSA id d76sm8691963qkb.57.2019.11.04.10.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 10:17:44 -0800 (PST)
Date:   Mon, 4 Nov 2019 13:17:42 -0500
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Keith Busch <kbusch@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [PATCH V4] block: optimize for small block size IO
Message-ID: <20191104181742.GC8984@kmo-pixel>
References: <20191102072911.24817-1-ming.lei@redhat.com>
 <20191104181403.GA8984@kmo-pixel>
 <20191104181541.GA21116@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104181541.GA21116@infradead.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Nov 04, 2019 at 10:15:41AM -0800, Christoph Hellwig wrote:
> On Mon, Nov 04, 2019 at 01:14:03PM -0500, Kent Overstreet wrote:
> > On Sat, Nov 02, 2019 at 03:29:11PM +0800, Ming Lei wrote:
> > > __blk_queue_split() may be a bit heavy for small block size(such as
> > > 512B, or 4KB) IO, so introduce one flag to decide if this bio includes
> > > multiple page. And only consider to try splitting this bio in case
> > > that the multiple page flag is set.
> > 
> > So, back in the day I had an alternative approach in mind: get rid of
> > blk_queue_split entirely, by pushing splitting down to the request layer - when
> > we map the bio/request to sgl, just have it map as much as will fit in the sgl
> > and if it doesn't entirely fit bump bi_remaining and leave it on the request
> > queue.
> > 
> > This would mean there'd be no need for counting segments at all, and would cut a
> > fair amount of code out of the io path.
> 
> I thought about that to, but it will take a lot more effort.  Mostly
> because md/dm heavily rely on splitting as well.  I still think it is
> worthwhile, it will just take a significant amount of time and we
> should have the quick improvement now.

We can do it one driver at a time - driver sets a flag to disable
blk_queue_split(). Obvious one to do first would be nvme since that's where it
shows up the most.

And md/md do splitting internally, but I'm not so sure they need
blk_queue_split().

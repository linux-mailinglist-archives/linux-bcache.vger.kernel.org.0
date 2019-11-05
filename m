Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF2C7EF344
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Nov 2019 03:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbfKECLf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Nov 2019 21:11:35 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46222 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbfKECLf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Nov 2019 21:11:35 -0500
Received: by mail-qt1-f196.google.com with SMTP id u22so27126600qtq.13;
        Mon, 04 Nov 2019 18:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W0+7k1DRafJ+r2YfPcqo1EdMvigU/iVfY/W/noJefnI=;
        b=VJZT7qBEe0DMw1OYRW8Nbq7dkKMRGPSE+deEt5uexE8da96FsaX3djNlEquJFmw4zz
         Rm33SODNu8MpxIA2lRQB2IaHO3hk0FrSlTCZJHv1talWB+jWlhB3VJcklrm4fbDxO9ig
         4dLOFvIPnMr2BjXbrK4u2ivTvAzvVilCKlBg1qeJgFLy+H37xi216SxmUvbjg0FmXjYo
         AGwBnw3k/Y58TPzfFBXq3l31WjtR9d3MoSIz/Nw6X1A8byaSbGp79MMgFkuPQsVzhrYy
         PqPFYAQ83wZ/+2p9BLhkYFu380iMG8r8m93yUwtj7KaXWx2AcAaLlihEQhQBHZRMKQJs
         SseQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W0+7k1DRafJ+r2YfPcqo1EdMvigU/iVfY/W/noJefnI=;
        b=sYji6e8qp2bMql+ezSeOtAU0+msicRGT4MMhecHr/Lth3o0HFqNcrEXSiVlDKfBqHv
         RZLsvxVJgGW/0Qm2EhVelZGCBra1MNbtmqkuEOcIpjuGiWH2F2BIQEiO8cy2fvLFnFdR
         3N4UlNKVrl4rncluAjjqEpRVJQzyAEZ4lxocGqYcmsKrQjYnIJxwhl3O7mp3sWuaXYpj
         cmmPcPvWzMY2IwHz0wS8Q0r5yjz4x7fbukTE9Ykqcncn5lsAKAFylgxHLxZj1a/ZDvMj
         4oP4GRjW4NnFdxKBXbzg1gVUx9Xtwr+4ZONEMAg1EzQp6+2M9IvgzBB7omtXh42MmWOP
         qgJA==
X-Gm-Message-State: APjAAAVoucxMO/blHTDifN88rpJTxZPmdrzayQdQEJvqmw+3ZRy5KGZ3
        9H4h99F7j2d4xbngAwyRlg==
X-Google-Smtp-Source: APXvYqyAHboqhEcn3AO/tqBd4xAJPyzUQF6B/TNyR/OU2id4uWSEPC5Q/L/Cp+4kXW79nZcRKjuR/A==
X-Received: by 2002:ac8:89c:: with SMTP id v28mr15558195qth.156.1572919894330;
        Mon, 04 Nov 2019 18:11:34 -0800 (PST)
Received: from moria.home.lan ([2601:19b:c500:a1:7285:c2ff:fed5:c918])
        by smtp.gmail.com with ESMTPSA id 189sm9896682qki.10.2019.11.04.18.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 18:11:32 -0800 (PST)
Date:   Mon, 4 Nov 2019 21:11:30 -0500
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Keith Busch <kbusch@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [PATCH V4] block: optimize for small block size IO
Message-ID: <20191105021130.GB18564@moria.home.lan>
References: <20191102072911.24817-1-ming.lei@redhat.com>
 <20191104181403.GA8984@kmo-pixel>
 <20191104181541.GA21116@infradead.org>
 <20191104181742.GC8984@kmo-pixel>
 <f7fab4e0-58e4-76e4-a503-bb535b2a3da6@kernel.dk>
 <20191104184217.GD8984@kmo-pixel>
 <20191105011135.GD11436@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105011135.GD11436@ming.t460p>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Nov 05, 2019 at 09:11:35AM +0800, Ming Lei wrote:
> On Mon, Nov 04, 2019 at 01:42:17PM -0500, Kent Overstreet wrote:
> > On Mon, Nov 04, 2019 at 11:23:42AM -0700, Jens Axboe wrote:
> > > On 11/4/19 11:17 AM, Kent Overstreet wrote:
> > > > On Mon, Nov 04, 2019 at 10:15:41AM -0800, Christoph Hellwig wrote:
> > > >> On Mon, Nov 04, 2019 at 01:14:03PM -0500, Kent Overstreet wrote:
> > > >>> On Sat, Nov 02, 2019 at 03:29:11PM +0800, Ming Lei wrote:
> > > >>>> __blk_queue_split() may be a bit heavy for small block size(such as
> > > >>>> 512B, or 4KB) IO, so introduce one flag to decide if this bio includes
> > > >>>> multiple page. And only consider to try splitting this bio in case
> > > >>>> that the multiple page flag is set.
> > > >>>
> > > >>> So, back in the day I had an alternative approach in mind: get rid of
> > > >>> blk_queue_split entirely, by pushing splitting down to the request layer - when
> > > >>> we map the bio/request to sgl, just have it map as much as will fit in the sgl
> > > >>> and if it doesn't entirely fit bump bi_remaining and leave it on the request
> > > >>> queue.
> > > >>>
> > > >>> This would mean there'd be no need for counting segments at all, and would cut a
> > > >>> fair amount of code out of the io path.
> > > >>
> > > >> I thought about that to, but it will take a lot more effort.  Mostly
> > > >> because md/dm heavily rely on splitting as well.  I still think it is
> > > >> worthwhile, it will just take a significant amount of time and we
> > > >> should have the quick improvement now.
> > > > 
> > > > We can do it one driver at a time - driver sets a flag to disable
> > > > blk_queue_split(). Obvious one to do first would be nvme since that's where it
> > > > shows up the most.
> > > > 
> > > > And md/md do splitting internally, but I'm not so sure they need
> > > > blk_queue_split().
> > > 
> > > I'm a big proponent of doing something like that instead, but it is a
> > > lot of work. I absolutely hate the splitting we're doing now, even
> > > though the original "let's work as hard as we add add page time to get
> > > things right" was pretty abysmal as well.
> > 
> > Last I looked I don't think it was going to be that bad, just needed a bit of
> > finesse. We just need to be able to partially process a request in e.g.
> > nvme_map_data(), and blk_rq_map_sg() needs to be modified to only map as much as
> > will fit instead of popping an assertion.
> 
> I think it may not be doable.
> 
> blk_rq_map_sg() is called by drivers and has to work on single request, however
> more requests have to be involved if we delay the splitting to blk_rq_map_sg().
> Cause splitting means that two bios can't be submitted in single IO request.

Of course it's doable, do I have to show you how?

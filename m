Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5201D302975
	for <lists+linux-bcache@lfdr.de>; Mon, 25 Jan 2021 19:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731250AbhAYSAF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 Jan 2021 13:00:05 -0500
Received: from verein.lst.de ([213.95.11.211]:45049 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729837AbhAYR4W (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 Jan 2021 12:56:22 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1DB9C68B02; Mon, 25 Jan 2021 18:55:29 +0100 (CET)
Date:   Mon, 25 Jan 2021 18:55:28 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>,
        Coly Li <colyli@suse.de>, Song Liu <song@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-bcache <linux-bcache@vger.kernel.org>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: do not reassig ->bi_bdev when partition
 remapping
Message-ID: <20210125175528.GA13451@lst.de>
References: <20210124100241.1167849-1-hch@lst.de> <20210124100241.1167849-6-hch@lst.de> <dfdff48c-c263-8e7c-cb52-28e7bee00c45@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfdff48c-c263-8e7c-cb52-28e7bee00c45@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Jan 25, 2021 at 10:53:36AM -0700, Jens Axboe wrote:
> On Sun, Jan 24, 2021 at 3:05 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > There is no good reason to reassign ->bi_bdev when remapping the
> > partition-relative block number to the device wide one, as all the
> > information required by the drivers comes from the gendisk anyway.
> >
> > Keeping the original ->bi_bdev alive will allow to greatly simplify
> > the partition-away I/O accounting.
> 
> This one causes boot failures for me on my laptop...

Any output to share?  Details of the config?

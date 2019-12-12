Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25B0611D112
	for <lists+linux-bcache@lfdr.de>; Thu, 12 Dec 2019 16:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbfLLPed (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 12 Dec 2019 10:34:33 -0500
Received: from verein.lst.de ([213.95.11.211]:34433 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729013AbfLLPed (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 12 Dec 2019 10:34:33 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4F2E368B05; Thu, 12 Dec 2019 16:34:30 +0100 (CET)
Date:   Thu, 12 Dec 2019 16:34:30 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Liang C <liangchen.linux@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: bcache kbuild cleanups
Message-ID: <20191212153430.GA10543@lst.de>
References: <20191209093829.19703-1-hch@lst.de> <b19f677f-d8e5-44af-0575-d1fb74835c65@suse.de> <CAKhg4tJGWwm5cTkctuch-ACrDOLfLKK8HCCTcJZPF2iURc9rUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKhg4tJGWwm5cTkctuch-ACrDOLfLKK8HCCTcJZPF2iURc9rUg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Dec 11, 2019 at 11:17:44PM +0800, Liang C wrote:
>  > Hi Coly and Liang,
>  >
>  > can you review this series to sort out the bcache superblock reading for
>  > larger page sizes?  I don't have bcache test setup so this is compile
>  > tested only.
>  >
> Hi Christoph,
> 
> Thanks for making the patches. I looked through them, but didn't see
> where cache and cached_dev have their sb_disk assigned.
> That would be an issue when __write_super tries to add the
> corresponding page to the bio. Not sure if there is there anything I
> missed.

Yes, that was missing.

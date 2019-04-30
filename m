Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1683FFC43
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Apr 2019 17:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfD3PHQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 30 Apr 2019 11:07:16 -0400
Received: from verein.lst.de ([213.95.11.211]:47065 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbfD3PHQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Apr 2019 11:07:16 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 1F0C267358; Tue, 30 Apr 2019 17:06:59 +0200 (CEST)
Date:   Tue, 30 Apr 2019 17:06:58 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: simplify bio_for_each_segment_all
Message-ID: <20190430150658.GA25407@lst.de>
References: <20190425070300.3388-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425070300.3388-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

ping?

On Thu, Apr 25, 2019 at 09:02:58AM +0200, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series simplifies bio_for_each_segment_all a bit, as suggested
> by willy.
---end quoted text---

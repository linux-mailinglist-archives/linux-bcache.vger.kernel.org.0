Return-Path: <linux-bcache+bounces-699-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F38991C3B0
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2024 18:25:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA2AA1F21895
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2024 16:25:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 751F81C9EB9;
	Fri, 28 Jun 2024 16:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XLkvA8CL"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15CA1C9EA2
	for <linux-bcache@vger.kernel.org>; Fri, 28 Jun 2024 16:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719591933; cv=none; b=rssoqTa2h9277rqv5i4/ljeLb3KpGWwRYdN5N9ULljKJSHiBN9irh643LOakjV7vdJU/nOpoHGDn6v9SeHO/7dFFX6coDxreFF3MPd6xfgMRudKTAWvmFqAZLem9APZpgg0dsHVkeuaG1xrFnTQfDtHXGkQ8SB5jVaGCL6g9LIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719591933; c=relaxed/simple;
	bh=WlXd8JmFgVfWVxJAjdqpboMIxClnQP8ideSJXjwBrBI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qQ3ek3HhIxOJR5fiRRsvv8ev35NJlgLfeWTGhVEVTABVYwbNev6lMjI4pIBQ5JiR2b+HEYYXGys185vrbzYIt1WiXsuSoHzJZgCDGUQ1m0mvROwt6t+J4YKgtiNwxvhii/EULekFIkxvdHyajILtPsUrRKCUSy02Fm1CXd3F/1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XLkvA8CL; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3d56102f134so38709b6e.1
        for <linux-bcache@vger.kernel.org>; Fri, 28 Jun 2024 09:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719591930; x=1720196730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gmIt5qvmSTkucPG+SeSrsMxC1GSwXlzZ1iTHCUvMAZo=;
        b=XLkvA8CLRXFIvMEPzkGiVOCy4JfuJ5oZQ4Ktn3sdQoiVBNNnDbF7fvHY5qTFhyfv9x
         aNK7J6MhE1kUI8G8De1k6yNL7ElbOjHliX9Gv3Fj60NaqPXpAfrgApFbIB0VukSxif7K
         dg2gdutx0HRV1XdCmTAWc63OFaBxC2wNXGBc3XXoUW9t2lWZ6OJQ3/Y0OGnXF0gd2YSj
         ZJlzrDNmXysc7r9UKSTVo0wZNZMUpU+n2ETY6vUhyXPYnBEgLi0GJPih00Z0MKztbUQ9
         XTexFaOicIAKBJmMwBOXoo9AAoAUBl0JYSAHwUzfsm9irlRkCkrQXgHDxm6UaSlYskzC
         vOFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719591930; x=1720196730;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gmIt5qvmSTkucPG+SeSrsMxC1GSwXlzZ1iTHCUvMAZo=;
        b=ZILEXpNLO+QkoaZ5V3E82t02ofA7uA08O4tspYsxez5asI1JULEEjmHXDRbKc33xVx
         c5lTg++A1x84OCGfLa7lRTI641Vom9Qod72sAkGKq7GoeOpm7BAxkdrWcHr3X2uwKVEB
         Cwa3Ial+6hqqTqkMLY2zhizaMuDhjpLFRoIGmZV7mUxYMK5B9oD3u1oAuelZZF8a2IOX
         KxlnIrH1e/qWg3KQWj75FMy/uz/xFW1roxtLE4LiqqpGsyWCXUomcuEBthEdh7Km0mfD
         s7FGHJSqyJx/LX7Xnzgrl1xXFEHx/+fSk8M05znThzyaxVDlY5jc9UWumUKnNd2pY7QS
         qwHg==
X-Forwarded-Encrypted: i=1; AJvYcCVuB3zFnR7BG0/KC/kDTtNoSkBWhK0wdzb3nNw4WoxBiWu2hRx4p3kgv9vTMKZoWmKteANlpLzp7ZB/PdzF2yeSqqb05Jdkd0kiTLfp
X-Gm-Message-State: AOJu0YwcGCiNJTyDbLNeQx3Y66nynPTiYPpEwlDQ9K+b2qDP+r/j2jPk
	jbBmrsQJSGOawoIZxkb+WmDliCpYcSh6E1PwajJRpT0ej+Kqg679cBJE601ZleHdXfR/l6hETq2
	B6Oo=
X-Google-Smtp-Source: AGHT+IHczAdp6vJXrek4hDM+fYtM83fhK1znVHtTO6nE7dHzwj+q0bkmmEt0yVtca+LvE2HMhBt3kQ==
X-Received: by 2002:a05:6808:199d:b0:3d5:6338:49ef with SMTP id 5614622812f47-3d563384b22mr7941101b6e.5.1719591929799;
        Fri, 28 Jun 2024 09:25:29 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d62f9c7c51sm354432b6e.18.2024.06.28.09.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 09:25:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: colyli@suse.de, kent.overstreet@linux.dev, linux-bcache@vger.kernel.org, 
 linux-block@vger.kernel.org, kernel test robot <lkp@intel.com>
In-Reply-To: <20240628131657.667797-1-hch@lst.de>
References: <20240628131657.667797-1-hch@lst.de>
Subject: Re: [PATCH] bcache: work around a __bitwise to bool conversion
 sparse warning
Message-Id: <171959192878.886023.14158886545448500224.b4-ty@kernel.dk>
Date: Fri, 28 Jun 2024 10:25:28 -0600
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Fri, 28 Jun 2024 15:16:48 +0200, Christoph Hellwig wrote:
> Sparse is a bit dumb about bitwise operation on __bitwise types used
> in boolean contexts.  Add a !! to explicitly propagate to boolean
> without a warning.
> 
> 

Applied, thanks!

[1/1] bcache: work around a __bitwise to bool conversion sparse warning
      commit: f1e46758e8b2b04c725ac706b5f455c0de0486a4

Best regards,
-- 
Jens Axboe





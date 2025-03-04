function [leftInvolute, rightInvolute] = generateInvolutesForPolygon(perimeter, start, startSection, alphaOffset)

leftInvolute.X = @(alpha,offset) leftCenterX(alpha+alphaOffset) + cos(alpha+alphaOffset-pi)*ropeLengthLeft(alpha+alphaOffset,offset);
leftInvolute.Y = @(alpha,offset) leftCenterY(alpha+alphaOffset) + sin(alpha+alphaOffset-pi)*ropeLengthLeft(alpha+alphaOffset,offset);

rightInvolute.X = @(alpha,offset) rightCenterX(-alpha+alphaOffset) + cos(-alpha+alphaOffset)*ropeLengthRight(-alpha+alphaOffset,offset);
rightInvolute.Y = @(alpha,offset) rightCenterY(-alpha+alphaOffset) + sin(-alpha+alphaOffset)*ropeLengthRight(-alpha+alphaOffset,offset);

    function x = leftCenterX(alpha)
        section = leftSectionOnPerimeter(alpha);
        x = perimeter(section).EndPoint(1,1);
    end
    function y = leftCenterY(alpha)
        section = leftSectionOnPerimeter(alpha);
        y = perimeter(section).EndPoint(1,2);
    end
    function x = rightCenterX(alpha)
        section = rightSectionOnPerimeter(alpha);
        x = perimeter(section).StartPoint(1,1);
    end
    function y = rightCenterY(alpha)
        section = rightSectionOnPerimeter(alpha);
        y = perimeter(section).StartPoint(1,2);
    end
    function length = ropeLengthLeft(alpha,offset)
        section = leftSectionOnPerimeter(alpha);
        if startSection <= section
            length = perimeter(section).CumSum-start;
        else
            length = perimeter(end).CumSum-start + perimeter(section).CumSum;
        end
        length = length - offset;
    end
    function length = ropeLengthRight(alpha,offset)
        section = rightSectionOnPerimeter(alpha);
        if startSection < section
            length = start + perimeter(end).CumSum - perimeter(section-1).CumSum;
        elseif startSection == section
            if section == 1
                length = start;
            else
                length = start - perimeter(section-1).CumSum;
            end
        else
            if section == 1
                length = start - perimeter(startSection-1).CumSum + perimeter(startSection-1).CumSum;
            else
                length = start - perimeter(startSection-1).CumSum + perimeter(startSection-1).CumSum-perimeter(section-1).CumSum;
            end
        end
        length = length - offset;
    end
    function section = leftSectionOnPerimeter(alpha)
        alpha = myWrapTo2Pi(alpha);
        section = 0;
        orientation = zeros(size(perimeter,1),1);
        for i=1:size(perimeter,1)-1
            orientation(i) = perimeter(i).Orientation;
            if perimeter(i).Orientation <= alpha && alpha < perimeter(i+1).Orientation
                section = i;
            end
        end
        if section == 0
            if perimeter(end).Orientation <= alpha && alpha < perimeter(1).Orientation
                section = size(perimeter,1);
            else
                orientation(end) = perimeter(end).Orientation;
                [~,section] = max(orientation);
            end
        end
    end
    function section = rightSectionOnPerimeter(alpha)
        alpha = myWrapTo2Pi(alpha);
        section = 0;
        orientation = zeros(size(perimeter,1),1);
        for i=size(perimeter,1):-1:2
            orientation(i) = perimeter(i).Orientation;
            if perimeter(i-1).Orientation < alpha && alpha <= perimeter(i).Orientation
                section = i;
            end
        end
        if section == 0
            if perimeter(end).Orientation < alpha && alpha <= perimeter(1).Orientation
                section = 1;
            else
                orientation(1) = perimeter(1).Orientation;
                [~,section] = min(orientation);
            end
        end
    end
end